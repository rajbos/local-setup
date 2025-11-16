# Paths
$modelsRoot = "$env:USERPROFILE\.ollama\models"
$manifestPath = Join-Path $modelsRoot "manifests"
$logFile = Join-Path $modelsRoot "model_registration.log"

# Default Modelfile content
$defaultParams = @"
PARAMETER temperature 0.7
PARAMETER top_p 0.9
PARAMETER num_ctx 4096

TEMPLATE """
{{ .Prompt }}
"""
"@

# Start logging
"=== Ollama Model Registration Log ===" | Out-File $logFile

# Get all model names from manifests
$modelNames = Get-ChildItem -Path $manifestPath -File | ForEach-Object {
    $_.BaseName
}

Write-Host "Found models: $($modelNames -join ', ')"

foreach ($model in $modelNames) {
    try {
        $modelFolder = Join-Path $modelsRoot $model
        $modelfilePath = Join-Path $modelFolder "Modelfile"

        # Create folder if missing
        if (-Not (Test-Path $modelFolder)) {
            New-Item -ItemType Directory -Path $modelFolder | Out-Null
        }

        # Create Modelfile if missing
        if (-Not (Test-Path $modelfilePath)) {
            $content = "FROM $model`r`n`r`n$defaultParams"
            Set-Content -Path $modelfilePath -Value $content
            Add-Content $logFile "[$(Get-Date)] Created Modelfile for $model"
        } else {
            Add-Content $logFile "[$(Get-Date)] Modelfile already exists for $model, skipping creation"
        }

        # Register model
        Write-Host "Registering $model..."
        $result = & ollama create $model -f $modelfilePath 2>&1

        if ($LASTEXITCODE -eq 0) {
            Add-Content $logFile "[$(Get-Date)] Successfully registered $model"
        } else {
            Add-Content $logFile "[$(Get-Date)] ERROR registering $model: $result"
        }
    }
    catch {
        $errorMsg = $_.Exception.Message
        Add-Content $logFile "[$(Get-Date)] EXCEPTION for $model: $errorMsg"
        Write-Host "Error processing $model: $errorMsg"
    }
}

Write-Host "Done! Check the log file at: $logFile"