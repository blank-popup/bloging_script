# ============================================================
# Configuration
# ============================================================

$ConfigPath = Join-Path $PSScriptRoot "config.ps1"

if (-not (Test-Path -LiteralPath $ConfigPath)) {
    Write-Error "Configuration file not found: $ConfigPath"
    exit 1
}

. $ConfigPath


# ============================================================
# Root
# ============================================================

$Root = (Resolve-Path $ProjectRoot).Path
$ProjectName = Split-Path $Root -Leaf

if ([string]::IsNullOrEmpty($ProjectName)) {
    $ProjectName = $Root
}

$Output = Join-Path $ZipOutputDirectory $ZipOutputName
$OutputFullPath = [System.IO.Path]::GetFullPath($Output)


# ============================================================
# Collect Files
# ============================================================

$Files = Get-ChildItem -LiteralPath $Root -Recurse -File |
    Where-Object {

        $FullPath = [System.IO.Path]::GetFullPath($_.FullName)

        # Exclude the output ZIP itself.
        if ($FullPath -eq $OutputFullPath) {
            return $false
        }

        $RelativePath = $FullPath.Substring($Root.Length).TrimStart('\')

        # Exclude configured directories.
        foreach ($directory in $ZipExcludeDirectories) {

            if ([string]::IsNullOrWhiteSpace($directory)) {
                continue
            }

            $DirectoryPattern = [regex]::Escape($directory)

            if (
                $RelativePath -eq $directory -or
                $RelativePath.StartsWith("$directory\") -or
                $RelativePath -match "\\$DirectoryPattern\\"
            ) {
                return $false
            }
        }

        # Exclude configured files.
        foreach ($pattern in $ZipExcludeFiles) {

            if ([string]::IsNullOrWhiteSpace($pattern)) {
                continue
            }

            if ($_.Name -like $pattern) {
                return $false
            }
        }

        return $true
    }


# ============================================================
# Temporary Directory
# ============================================================

$TempRoot = Join-Path $env:TEMP "czip_$([guid]::NewGuid())"
$TempProject = Join-Path $TempRoot $ProjectName

New-Item `
    -ItemType Directory `
    -Path $TempProject `
    -Force |
    Out-Null


# ============================================================
# Copy Files
# ============================================================

try {

    foreach ($File in $Files) {

        $RelativePath = $File.FullName.Substring($Root.Length).TrimStart('\')
        $Destination = Join-Path $TempProject $RelativePath
        $DestinationDirectory = Split-Path $Destination -Parent

        if (-not (Test-Path -LiteralPath $DestinationDirectory)) {
            New-Item `
                -ItemType Directory `
                -Path $DestinationDirectory `
                -Force |
                Out-Null
        }

        Copy-Item `
            -LiteralPath $File.FullName `
            -Destination $Destination `
            -Force
    }


    # ========================================================
    # Output
    # ========================================================

    $OutputDirectory = Split-Path $OutputFullPath -Parent

    if (-not (Test-Path -LiteralPath $OutputDirectory)) {
        New-Item `
            -ItemType Directory `
            -Path $OutputDirectory `
            -Force |
            Out-Null
    }

    # if (Test-Path -LiteralPath $OutputFullPath) {
    #     Remove-Item -LiteralPath $OutputFullPath -Force
    # }
    # ========================================================
    # Existing ZIP File Check
    # ========================================================

    if (Test-Path -LiteralPath $OutputFullPath) {

        Write-Output ""
        Write-Output "ZIP file already exists:"
        Write-Output "$OutputFullPath"
        Write-Output ""

        $answer = Read-Host "Overwrite? (Y/N)"

        if ($answer -ne "Y" -and $answer -ne "y") {

            Write-Output ""
            Write-Output "Compression cancelled."
            Write-Output ""

            return
        }

        Remove-Item `
            -LiteralPath $OutputFullPath `
            -Force
    }

    Compress-Archive `
        -Path $TempProject `
        -DestinationPath $OutputFullPath `
        -CompressionLevel Optimal


    # ========================================================
    # Result
    # ========================================================

    Write-Output ""
    Write-Output "Compression completed."
    Write-Output ""
    Write-Output "Source : $Root"
    Write-Output "Output : $OutputFullPath"
    Write-Output ""

}
finally {

    # Remove temporary directory.
    if (Test-Path -LiteralPath $TempRoot) {
        Remove-Item `
            -LiteralPath $TempRoot `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue
    }
}
