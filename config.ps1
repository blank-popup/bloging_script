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
    # ".ruff_cache"
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
    ".ruff_cache"
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
    ".ruff_cache"
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

# Replace sensitive path components in cenv output.
#
# Pattern supports .NET regular expressions.
# Replacement is used only for displayed text.
$PathRedactions = @(
    @{
        Pattern     = 'C:\\Users\\[^\\]+'
        Replacement = 'C:\Users\<user>'
    }
)


# ------------------------------------------------------------
# ZIP Archive
# ------------------------------------------------------------

# Directories excluded from czip.
#
# These directories are not included in the ZIP archive.
$ZipExcludeDirectories = @(
    ".git"
    ".venv"
    "__pycache__"
    ".pytest_cache"
    ".ruff_cache"
    ".mypy_cache"
    "node_modules"
    "dist"
    "build"
)

# Files excluded from czip.
#
# PowerShell wildcard patterns can be used.
$ZipExcludeFiles = @(
    "*.pyc"
    "*.pyo"
    "*.log"
    ".DS_Store"
)

# ZIP output directory.
#
# The default value creates the ZIP file in the parent directory of the project root.
$ZipOutputDirectory = (Split-Path $ProjectRoot -Parent)
# $ZipOutputDirectory = "D:\WorkSpace"

# ZIP output file name.
#
# The default name is based on the project directory name.
# Example:
#   D:\Project\ahaapi -> ahaapi.zip
$ZipOutputName = "$(Split-Path $ProjectRoot -Leaf).zip"
