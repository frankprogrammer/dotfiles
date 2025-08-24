if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Install-Module -Name powershell-yaml -Scope CurrentUser -Force
}
Import-Module powershell-yaml

function Resolve-TargetPath($path) {
    if ($path.StartsWith("~")) {
        $path = $path -replace "^~", $env:USERPROFILE
    }
    return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($path)
}

# Get app name from first argument
if ($args.Count -lt 1) {
    Write-Error "Usage: .\install-dotfiles.ps1 <appname>"
    exit 1
}

$App = $args[0]

$DotfilesDir = "$PSScriptRoot"
$appDir = Join-Path $DotfilesDir $App
$configPath = Join-Path $appDir "install.conf.yaml"

if (-not (Test-Path $appDir)) {
    Write-Error "App '$App' not found in $DotfilesDir"
    exit 1
}

if (-not (Test-Path $configPath)) {
    Write-Error "Missing install.conf.yaml for '$App'"
    exit 1
}

Write-Host "Installing dotfiles for '$App'..."

# Load YAML config
$config = Get-Content $configPath | ConvertFrom-Yaml
$targetRoot = Resolve-TargetPath $config.installFolder

if (-not $targetRoot) {
    Write-Error "No 'target' defined in $configPath"
    exit 1
}

# Ensure target exists
if (-not (Test-Path $targetRoot)) {
    New-Item -ItemType Directory -Path $targetRoot -Force | Out-Null
}

# Mirror folder structure
Get-ChildItem -Recurse $appDir | Where-Object {
    $_.FullName -notlike "*install.conf.yaml"
} | ForEach-Object {
    $relativePath = $_.FullName.Substring($appDir.Length).TrimStart("\/")
    $target = Join-Path $targetRoot $relativePath

    if ($_.PSIsContainer) {
        if (-not (Test-Path $target)) {
            New-Item -ItemType Directory -Path $target -Force | Out-Null
        }
    } else {
		Copy-Item $_.FullName $target -Force
		Write-Host "Copied $($_.FullName) to $target"
    }
}
