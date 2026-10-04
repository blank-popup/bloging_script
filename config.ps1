# ============================================================
# Common Configuration
# ============================================================

# ------------------------------------------------------------
# Project
# ------------------------------------------------------------

$ProjectRoot = (Get-Location).Path


# ------------------------------------------------------------
# Directory Tree
# ------------------------------------------------------------

# Directories excluded completely from ctree.
$TreeExclude = @(
    # ".git"
    # ".venv"
    # "__pycache__"
    # ".pytest_cache"
    # ".mypy_cache"
)

# Directory depth rules for ctree.
#
# Depth0 = show directory only
# Depth1 = show directory and immediate children
# Depth2 = show two levels
#
# Example:
# $TreeDepth0 = @(
#     ".venv"
# )
#
# $TreeDepth1 = @(
#     "node_modules"
# )

$TreeDepth0 = @(
    ".git"
    ".venv"
    "__pycache__"
    ".pytest_cache"
    ".mypy_cache"
)

$TreeDepth1 = @(
)

$TreeDepth2 = @(
)


# ------------------------------------------------------------
# Code Outline
# ------------------------------------------------------------

# File extensions analyzed by coutline.
$OutlineExtensions = @(
    ".py"
)

# Directories excluded from coutline.
$OutlineExclude = @(
    ".git"
    ".venv"
    "__pycache__"
    ".pytest_cache"
    ".mypy_cache"
)


# ------------------------------------------------------------
# Environment
# ------------------------------------------------------------

# Commands checked by cenv.
$EnvironmentCommands = @(
    "python"
    "uv"
    "git"
)

# Show PowerShell version.
$ShowPowerShellVersion = $true

# Show operating system information.
$ShowOperatingSystem = $true
