$ErrorActionPreference = "Stop"

function Get-FlutterCommand() {
  $cmd = Get-Command flutter -ErrorAction SilentlyContinue
  if ($cmd) { return $cmd.Source }

  if ($env:FLUTTER_BIN -and (Test-Path $env:FLUTTER_BIN)) {
    return $env:FLUTTER_BIN
  }

  throw "Flutter not found. Restart your terminal or add Flutter to PATH (add <flutter>\bin). Alternatively set `$env:FLUTTER_BIN to your flutter.bat path."
}

$flutter = Get-FlutterCommand

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$templateDir = Join-Path $root "template"
$appDir = Join-Path $root "app"

if (-not (Test-Path $templateDir)) {
  throw "Template folder not found: $templateDir"
}

if (-not (Test-Path $appDir)) {
  New-Item -ItemType Directory -Path $appDir | Out-Null
  Push-Location $appDir
  try {
    & $flutter create . --project-name todo_flutter --org com.example --platforms android,ios,web,windows,macos,linux | Write-Output
  } finally {
    Pop-Location
  }
} else {
  Write-Output "App folder already exists: $appDir"
}

function Copy-TemplateItem([string]$relativePath) {
  $src = Join-Path $templateDir $relativePath
  $dst = Join-Path $appDir $relativePath
  $dstParent = Split-Path -Parent $dst
  if (-not (Test-Path $dstParent)) {
    New-Item -ItemType Directory -Path $dstParent | Out-Null
  }
  Copy-Item -Path $src -Destination $dst -Force
}

Copy-TemplateItem "pubspec.yaml"
Copy-TemplateItem "analysis_options.yaml"

# Copy lib/ recursively
$libSrc = Join-Path $templateDir "lib"
$libDst = Join-Path $appDir "lib"
if (Test-Path $libDst) {
  Remove-Item -Recurse -Force $libDst
}
Copy-Item -Recurse -Force -Path $libSrc -Destination $libDst

# Remove template artifacts if present
$servicesDir = Join-Path $appDir "lib\\services"
if (Test-Path $servicesDir) {
  Remove-Item -Recurse -Force $servicesDir
}

Write-Output ""
Write-Output "Done."
Write-Output "Next:"
Write-Output "  cd `"$appDir`""
Write-Output "  flutter pub get"
Write-Output "  flutter run"

