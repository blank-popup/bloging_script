# ============================================================
# Development Environment Information
# ============================================================

$ConfigPath = Join-Path $PSScriptRoot "config.ps1"

if (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) {
    Write-Error "Configuration file not found: $ConfigPath"
    exit 1
}

. $ConfigPath


# ============================================================
# Helper Functions
# ============================================================

function Get-ExecutableVersion {
    param(
        [string]$ExecutablePath
    )

    if ([string]::IsNullOrEmpty($ExecutablePath)) {
        return "Not found"
    }

    if (-not (Test-Path -LiteralPath $ExecutablePath -PathType Leaf)) {
        return "Not found"
    }

    try {
        $output = & $ExecutablePath --version 2>&1

        if ($LASTEXITCODE -ne 0) {
            return "Not available"
        }

        if ($output) {
            return (($output | Select-Object -First 1).ToString()).Trim()
        }

        return "Not available"
    }
    catch {
        return "Not available"
    }
}


function Get-CommandPath {
    param(
        [string]$CommandName
    )

    $command = Get-Command $CommandName -ErrorAction SilentlyContinue

    if ($null -eq $command) {
        return $null
    }

    return $command.Source
}


function ConvertTo-DisplayPath {
    param(
        [string]$Path
    )

    if ([string]::IsNullOrEmpty($Path)) {
        return $Path
    }

    $DisplayPath = $Path

    foreach ($Rule in $PathRedactions) {

        if (
            $Rule.ContainsKey("Pattern") -and
            $Rule.ContainsKey("Replacement")
        ) {
            $DisplayPath = [regex]::Replace(
                $DisplayPath,
                $Rule.Pattern,
                $Rule.Replacement,
                [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
            )
        }
    }

    return $DisplayPath
}


# ============================================================
# Project
# ============================================================

Write-Output "Project"
Write-Output "-------"
Write-Output "Root: $(ConvertTo-DisplayPath $ProjectRoot)"
Write-Output ""


# ============================================================
# Operating System
# ============================================================

if ($ShowOperatingSystem) {

    $os = Get-CimInstance Win32_OperatingSystem

    $Architecture = switch -Regex ($os.OSArchitecture) {
        "64"   { "64-bit"; break }
        "86"   { "32-bit"; break }
        default { "Unknown" }
    }

    Write-Output "Operating System"
    Write-Output "----------------"
    Write-Output "Name: $($os.Caption)"
    Write-Output "Version: $($os.Version)"
    Write-Output "Architecture: $Architecture"
    Write-Output ""
}


# ============================================================
# PowerShell
# ============================================================

if ($ShowPowerShellVersion) {

    Write-Output "PowerShell"
    Write-Output "----------"
    Write-Output "Version: $($PSVersionTable.PSVersion)"
    Write-Output "Edition: $($PSVersionTable.PSEdition)"
    Write-Output ""
}


# ============================================================
# Python
# ============================================================

Write-Output "Python"
Write-Output "------"


# ------------------------------------------------------------
# System Python
# ------------------------------------------------------------

$SystemPython = Get-CommandPath "python"

if ($null -eq $SystemPython) {

    Write-Output "System:"
    Write-Output "  Status: Not found"

}
elseif ($SystemPython -like "*\WindowsApps\python.exe") {

    Write-Output "System:"
    Write-Output "  Status: Windows App Execution Alias"
    Write-Output "  Command: $(ConvertTo-DisplayPath $SystemPython)"

}
else {

    $SystemPythonVersion = Get-ExecutableVersion $SystemPython

    Write-Output "System:"
    Write-Output "  Status: Available"
    Write-Output "  Command: $(ConvertTo-DisplayPath $SystemPython)"
    Write-Output "  Version: $SystemPythonVersion"
}


# ------------------------------------------------------------
# Virtual Environment Python
# ------------------------------------------------------------

$VenvPython = Join-Path $ProjectRoot ".venv\Scripts\python.exe"

Write-Output ""
Write-Output "Virtual Environment:"

if (Test-Path -LiteralPath $VenvPython -PathType Leaf) {

    $VenvPythonVersion = Get-ExecutableVersion $VenvPython

    Write-Output "  Path: $(ConvertTo-DisplayPath $VenvPython)"
    Write-Output "  Version: $VenvPythonVersion"

    if ($env:VIRTUAL_ENV) {
        Write-Output "  Active: Yes"
    }
    else {
        Write-Output "  Active: No"
    }

}
else {

    Write-Output "  Status: .venv not found"
}


# ============================================================
# uv
# ============================================================

Write-Output ""
Write-Output "uv"
Write-Output "--"

$UvPath = Get-CommandPath "uv"

if ($null -eq $UvPath) {

    Write-Output "Status: Not installed"

}
else {

    $UvVersion = Get-ExecutableVersion $UvPath

    Write-Output "Status: Available"
    Write-Output "Command: $(ConvertTo-DisplayPath $UvPath)"
    Write-Output "Version: $UvVersion"


    # --------------------------------------------------------
    # uv Project Python
    # --------------------------------------------------------

    $CurrentLocation = Get-Location

    Push-Location $ProjectRoot

    try {

        $UvPythonOutput = & $UvPath run python --version 2>&1

        if ($LASTEXITCODE -eq 0 -and $UvPythonOutput) {

            $UvPythonVersion = (
                $UvPythonOutput |
                Select-Object -First 1
            ).ToString().Trim()

            Write-Output "Project Python: $UvPythonVersion"

        }
        else {

            Write-Output "Project Python: Not available"

        }

    }
    catch {

        Write-Output "Project Python: Not available"

    }
    finally {

        Pop-Location
    }
}


# ============================================================
# Development Tools
# ============================================================

Write-Output ""
Write-Output "Development Tools"
Write-Output "-----------------"

foreach ($command in $EnvironmentCommands) {

    # Python and uv are handled separately above.
    if ($command -eq "python") {
        continue
    }

    if ($command -eq "uv") {
        continue
    }

    $CommandPath = Get-CommandPath $command

    if ($null -eq $CommandPath) {

        Write-Output "$command : Not installed"

        continue
    }

    # Ignore Windows App Execution Alias.
    if ($CommandPath -like "*\WindowsApps\*.exe") {

        Write-Output "$command : Windows App Execution Alias"

        continue
    }

    $Version = Get-ExecutableVersion $CommandPath

    Write-Output "$command : $Version"
}
