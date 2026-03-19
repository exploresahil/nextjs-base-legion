# Restructuring script for Next.js default boilerplate
# This script transforms a fresh Next.js project into a preferred organized structure.
param(
    [string]$AppDir = "src/app",
    [string]$ScssDir = "src/app/(client)/scss"
)

$SkillRoot = Split-Path -Parent $PSScriptRoot
$AssetsDir = Join-Path $SkillRoot "assets"

# --- Cleanup Default Files ---
$FilesToRemove = @(
    (Join-Path $AppDir "globals.css"),
    (Join-Path $AppDir "page.module.css"),
    (Join-Path $AppDir "page.tsx")
)

foreach ($File in $FilesToRemove) {
    if (Test-Path $File) {
        Remove-Item -Path $File -Force
        Write-Host "Removed default file: $File"
    }
}

# Create directory structure
$ClientDir = Join-Path $AppDir "(client)"
$ClientScssDir = Join-Path $ClientDir "scss"
$AbstractsDir = Join-Path $ClientScssDir "abstracts"
$FontDir = Join-Path $AppDir "font"

New-Item -ItemType Directory -Force -Path $AppDir, $ClientDir, $ClientScssDir, $AbstractsDir, $FontDir

# --- Implement Fonts ---
Copy-Item -Path (Join-Path $AssetsDir "font/index.ts") -Destination (Join-Path $FontDir "index.ts") -Force

# --- Implement SCSS ---
Copy-Item -Path (Join-Path $AssetsDir "globals.scss") -Destination (Join-Path $AppDir "globals.scss") -Force
Copy-Item -Path (Join-Path $AssetsDir "abstracts/_functions.scss") -Destination $AbstractsDir -Force
Copy-Item -Path (Join-Path $AssetsDir "abstracts/index.scss") -Destination $AbstractsDir -Force
Copy-Item -Path (Join-Path $AssetsDir "abstracts/_variables.scss") -Destination $AbstractsDir -Force
Copy-Item -Path (Join-Path $AssetsDir "_defaults.scss") -Destination $ClientScssDir -Force
Copy-Item -Path (Join-Path $AssetsDir "client-globals.scss") -Destination (Join-Path $ClientScssDir "globals.scss") -Force

# --- Implement Layouts & Page ---
Copy-Item -Path (Join-Path $AssetsDir "root-layout.tsx") -Destination (Join-Path $AppDir "layout.tsx") -Force
Copy-Item -Path (Join-Path $AssetsDir "client-layout.tsx") -Destination (Join-Path $ClientDir "layout.tsx") -Force
Copy-Item -Path (Join-Path $AssetsDir "client-page.tsx") -Destination (Join-Path $ClientDir "page.tsx") -Force

# --- Dependency Management ---
$PackageJsonPath = Join-Path (Get-Location) "package.json"
if (Test-Path $PackageJsonPath) {
    $PackageJson = Get-Content $PackageJsonPath | ConvertFrom-Json
    $HasSass = $null -ne $PackageJson.devDependencies.sass
    $HasLenis = $null -ne $PackageJson.dependencies.lenis

    # Install Sass
    if (-not $HasSass) {
        Write-Host "Sass not found in devDependencies. Installing..."
        if (Test-Path "pnpm-lock.yaml") {
            pnpm add -D sass
        } elseif (Test-Path "package-lock.json") {
            npm install -D sass
        } elseif (Test-Path "yarn.lock") {
            yarn add -D sass
        } else {
            npm install -D sass
        }
    }

    # Install Lenis (required for ClientLayout)
    if (-not $HasLenis) {
        Write-Host "Lenis not found. Installing..."
        if (Test-Path "pnpm-lock.yaml") {
            pnpm add lenis
        } elseif (Test-Path "package-lock.json") {
            npm install lenis
        } elseif (Test-Path "yarn.lock") {
            yarn add lenis
        } else {
            npm install lenis
        }
    }
} else {
    Write-Warning "package.json not found. Please ensure sass and lenis are installed manually."
}

Write-Host "Successfully implemented SCSS and Layout base structure in $AppDir"
