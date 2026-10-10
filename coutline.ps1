# ============================================================
# Python Code Outline
# ============================================================

$ConfigPath = Join-Path $PSScriptRoot "config.ps1"

if (-not (Test-Path -LiteralPath $ConfigPath)) {
    Write-Error "Configuration file not found: $ConfigPath"
    exit 1
}

. $ConfigPath


# ============================================================
# Python Script
# ============================================================

$PythonScript = Join-Path $PSScriptRoot "coutline.py"

if (-not (Test-Path -LiteralPath $PythonScript -PathType Leaf)) {
    Write-Error "Python script not found: $PythonScript"
    exit 1
}


# ============================================================
# Check uv
# ============================================================

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Error "uv is not installed or not available in PATH."
    exit 1
}


# ============================================================
# Arguments
# ============================================================

$Arguments = $args


# ============================================================
# Run
# ============================================================

uv run python $PythonScript @Arguments

$ExitCode = $LASTEXITCODE


# ============================================================
# Return Exit Code
# ============================================================

exit $ExitCode
