# Implementation script for nextjs-hooks-base skill
param(
    [string]$TargetDir = "src/hooks"
)

$SkillRoot = Split-Path -Parent $PSScriptRoot
$AssetsDir = Join-Path $SkillRoot "assets"

# Create directories
New-Item -ItemType Directory -Force -Path $TargetDir

# Copy assets
Copy-Item -Path (Join-Path $AssetsDir "useBrowser.ts") -Destination $TargetDir -Force
Copy-Item -Path (Join-Path $AssetsDir "useLenisScrollTo.ts") -Destination $TargetDir -Force
Copy-Item -Path (Join-Path $AssetsDir "useResponsive.ts") -Destination $TargetDir -Force

# Check and install Lenis if not present
$PackageJsonPath = Join-Path (Get-Location) "package.json"
if (Test-Path $PackageJsonPath) {
    $PackageJson = Get-Content $PackageJsonPath | ConvertFrom-Json
    $HasLenis = ($null -ne $PackageJson.dependencies.lenis) -or ($null -ne $PackageJson.devDependencies.lenis)
    $HasLenisReact = ($null -ne $PackageJson.dependencies."lenis/react") -or ($null -ne $PackageJson.devDependencies."lenis/react")
    
    if (-not $HasLenis -or -not $HasLenisReact) {
        Write-Host "Lenis not found in dependencies. Installing..."
        if (Test-Path "pnpm-lock.yaml") {
            pnpm add lenis
        } elseif (Test-Path "package-lock.json") {
            npm install lenis
        } elseif (Test-Path "yarn.lock") {
            yarn add lenis
        } else {
            npm install lenis
        }
    } else {
        Write-Host "Lenis is already installed."
    }
} else {
    Write-Warning "package.json not found. Please ensure lenis is installed manually."
}

Write-Host "Successfully implemented Hooks base structure in $TargetDir"
