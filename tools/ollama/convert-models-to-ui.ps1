# Check if ollama command is available
if (-Not (Get-Command ollama -ErrorAction SilentlyContinue)) {
    Write-Host "Ollama command not found. Please ensure Ollama is installed and in PATH."
    exit 1
}

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

# Check if manifests directory exists
if (-Not (Test-Path $manifestPath)) {
    Write-Host "Manifests directory not found at: $manifestPath"
    exit 1
}

# Get all model names from manifests
$modelNames = Get-ChildItem -Path $manifestPath -File | ForEach-Object {
    $_.BaseName
}

Write-Host "Found $($manifestFiles.Count) model manifest(s)"

foreach ($manifestFile in $manifestFiles) {
    try {
        # Extract the relative path from the manifest directory
        # Example: registry.ollama.ai/library/llama2/latest -> llama2:latest
        $relativePath = $manifestFile.FullName.Substring($manifestPath.Length + 1)
        
        # Split the path to extract model and tag
        # Path structure: {registry}/{namespace}/{model}/{tag}
        $pathParts = $relativePath -split [regex]::Escape([IO.Path]::DirectorySeparatorChar)
        
        if ($pathParts.Count -ge 3) {
            # Extract model name and tag from the nested structure
            $modelName = $pathParts[-2]  # Second to last element is the model name
            $tag = $pathParts[-1]         # Last element is the tag
            $model = "${modelName}:${tag}"
            
            Write-Host "Processing model: $model (from $relativePath)"
            
            # Create a flat folder structure for the Modelfile
            $modelFolder = Join-Path $modelsRoot $modelName
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
        } else {
            Add-Content $logFile "[$(Get-Date)] WARNING: Skipping manifest with unexpected path structure: $relativePath"
            Write-Host "Warning: Skipping manifest with unexpected path: $relativePath"
        }
    }
    catch {
        $errorMsg = $_.Exception.Message
        Add-Content $logFile "[$(Get-Date)] EXCEPTION for $relativePath: $errorMsg"
        Write-Host "Error processing $relativePath: $errorMsg"
    }
}

Write-Host "Done! Check the log file at: $logFile"