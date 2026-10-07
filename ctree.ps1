# ============================================================
# Directory Tree
# ============================================================

$ConfigPath = Join-Path $PSScriptRoot "config.ps1"

if (-not (Test-Path -LiteralPath $ConfigPath)) {
    Write-Error "Configuration file not found: $ConfigPath"
    exit 1
}

. $ConfigPath


# ============================================================
# Build Depth Rules
# ============================================================

$DepthRules = @{}

Get-Variable -Scope Script |
    Where-Object {
        $_.Name -match '^TreeDepth(\d+)$'
    } |
    ForEach-Object {
        $depth = [int]$Matches[1]
        $directories = $_.Value

        if ($null -eq $directories) {
            return
        }

        foreach ($directory in $directories) {
            $DepthRules[$directory] = $depth
        }
    }


# ============================================================
# Root
# ============================================================

$Root = (Resolve-Path $ProjectRoot).Path
$RootName = Split-Path $Root -Leaf

if ([string]::IsNullOrEmpty($RootName)) {
    $RootName = $Root
}

Write-Output "$RootName/"


# ============================================================
# Write Tree
# ============================================================

function Write-Tree {
    param(
        [string]$CurrentPath,
        [string]$Prefix = "",
        [Nullable[int]]$MaxDepth = $null,
        [int]$CurrentDepth = 0
    )

    $items = @(
        Get-ChildItem -LiteralPath $CurrentPath -Force |
            Where-Object {
                $TreeExclude -notcontains $_.Name
            } |
            Sort-Object `
                @{Expression = {$_.PSIsContainer}; Descending = $true},
                Name
    )

    for ($i = 0; $i -lt $items.Count; $i++) {

        $item = $items[$i]
        $isLast = ($i -eq $items.Count - 1)

        if ($isLast) {
            $branch = "└── "
            $nextPrefix = "$Prefix    "
        }
        else {
            $branch = "├── "
            $nextPrefix = "$Prefix│   "
        }

        if ($item.PSIsContainer) {

            Write-Output "$Prefix$branch$($item.Name)/"

            # Apply directory-specific depth rule.
            if ($DepthRules.ContainsKey($item.Name)) {

                $depthLimit = $DepthRules[$item.Name]

                if ($depthLimit -eq 0) {
                    continue
                }

                Write-Tree `
                    -CurrentPath $item.FullName `
                    -Prefix $nextPrefix `
                    -MaxDepth $depthLimit `
                    -CurrentDepth 1

                continue
            }

            # No depth rule: recurse without limit.
            if ($null -eq $MaxDepth) {

                Write-Tree `
                    -CurrentPath $item.FullName `
                    -Prefix $nextPrefix
            }
            elseif ($CurrentDepth -lt $MaxDepth) {

                Write-Tree `
                    -CurrentPath $item.FullName `
                    -Prefix $nextPrefix `
                    -MaxDepth $MaxDepth `
                    -CurrentDepth ($CurrentDepth + 1)
            }
        }
        else {
            Write-Output "$Prefix$branch$($item.Name)"
        }
    }
}


# ============================================================
# Run
# ============================================================

Write-Tree -CurrentPath $Root
