# Implementation script for nextjs-utils-base skill
param(
    [string]$TargetDir = "src/utils"
)

$SkillRoot = Split-Path -Parent $PSScriptRoot
$AssetsDir = Join-Path $SkillRoot "assets"

# Create directories
New-Item -ItemType Directory -Force -Path $TargetDir

# Copy assets
Copy-Item -Path (Join-Path $AssetsDir "index.ts") -Destination $TargetDir -Force
Copy-Item -Path (Join-Path $AssetsDir "image.util.ts") -Destination $TargetDir -Force
Copy-Item -Path (Join-Path $AssetsDir "pxToRem.util.ts") -Destination $TargetDir -Force

# Check and install Zod if not present
$PackageJsonPath = Join-Path (Get-Location) "package.json"
if (Test-Path $PackageJsonPath) {
    $PackageJson = Get-Content $PackageJsonPath | ConvertFrom-Json
    $HasZod = ($null -ne $PackageJson.dependencies.zod) -or ($null -ne $PackageJson.devDependencies.zod)
    
    if (-not $HasZod) {
        Write-Host "Zod not found in dependencies. Installing..."
        if (Test-Path "pnpm-lock.yaml") {
            pnpm add zod
        } elseif (Test-Path "package-lock.json") {
            npm install zod
        } elseif (Test-Path "yarn.lock") {
            yarn add zod
        } else {
            npm install zod
        }
    } else {
        Write-Host "Zod is already installed."
    }
} else {
    Write-Warning "package.json not found. Please ensure zod is installed manually."
}

Write-Host "Successfully implemented Utils base structure in $TargetDir"
