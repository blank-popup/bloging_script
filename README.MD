# Project Documentation Scripts

A collection of PowerShell and Python scripts for quickly documenting and inspecting a software project.

The scripts are designed for use in a development project and are especially useful when creating technical documentation, blog posts, tutorials, or project overviews.

## Features

This project provides three main commands:

| Command | Purpose |
|---|---|
| `ctree` | Display the project directory structure |
| `coutline` | Display the structure of Python source code |
| `cenv` | Display the development environment information |

All scripts share a single configuration file:

```text
config.ps1
```

This allows project-specific settings to be managed in one place.

---

# Directory Structure

A typical setup looks like this:

```text
scripts/
├── config.ps1
├── ctree.ps1
├── coutline.ps1
├── coutline.py
└── cenv.ps1
```

The scripts can also be placed directly in the project root:

```text
myproject/
├── config.ps1
├── ctree.ps1
├── coutline.ps1
├── coutline.py
├── cenv.ps1
├── pyproject.toml
├── .venv/
└── ...
```

---

# Requirements

## PowerShell

The scripts are compatible with **Windows PowerShell 5.1**.

They do not require PowerShell 7.

## Python

Python is required for `coutline`.

The Python source analyzer uses the standard library `ast` module, so no additional Python packages are required.

## uv

`coutline` uses `uv run` to execute the Python analyzer.

Therefore, `uv` should be installed and available in `PATH`.

## Git

Git is optional.

If Git is installed, `cenv` displays the installed Git version.

---

# Configuration

All scripts use the same configuration file:

```text
config.ps1
```

A basic configuration looks like this:

```powershell
# ============================================================
# Common Configuration
# ============================================================

$ProjectRoot = (Get-Location).Path


# ============================================================
# Directory Tree
# ============================================================

$TreeExclude = @(
    ".git"
    "__pycache__"
    ".pytest_cache"
    ".mypy_cache"
)

$TreeDepth0 = @(
    ".venv"
)

$TreeDepth1 = @(
)

$TreeDepth2 = @(
)


# ============================================================
# Code Outline
# ============================================================

$OutlineExtensions = @(
    ".py"
)

$OutlineExclude = @(
    ".git"
    ".venv"
    "__pycache__"
)


# ============================================================
# Environment
# ============================================================

$EnvironmentCommands = @(
    "python"
    "uv"
    "git"
)

$ShowPowerShellVersion = $true

$ShowOperatingSystem = $true
```

The configuration file is loaded by all three scripts.

This means that project-specific settings can be changed without modifying the scripts themselves.

---

# ctree

`ctree` displays the directory structure of the current project in a tree format.

## Usage

```powershell
ctree
```

or:

```powershell
.\ctree.ps1
```

Example:

```text
myproject/
├── .gitignore
├── pyproject.toml
├── README.md
├── manage.py
├── .venv/
│   ├── Include/
│   ├── Lib/
│   └── Scripts/
├── config/
│   ├── settings.py
│   └── urls.py
└── app/
    ├── __init__.py
    ├── models.py
    ├── views.py
    └── serializers.py
```

## Excluding Directories

Directories that should not be displayed can be specified with `$TreeExclude`.

```powershell
$TreeExclude = @(
    ".git"
    ".venv"
    "__pycache__"
    ".pytest_cache"
    "node_modules"
)
```

Excluded directories are completely omitted from the tree.

---

## Directory Depth Rules

Some directories may contain a large number of files.

For example, displaying the entire `.venv` directory is usually unnecessary.

Depth rules can be used to limit how deeply a specific directory is displayed.

```powershell
$TreeDepth0 = @(
    ".venv"
)
```

Result:

```text
myproject/
├── .venv/
├── manage.py
└── pyproject.toml
```

### Depth 0

```powershell
$TreeDepth0 = @(
    ".venv"
)
```

Only the directory itself is displayed.

### Depth 1

```powershell
$TreeDepth1 = @(
    ".venv"
)
```

The directory and its immediate contents are displayed.

```text
.venv/
├── Include/
├── Lib/
└── Scripts/
```

### Depth 2

```powershell
$TreeDepth2 = @(
    ".venv"
)
```

Two levels below the target directory are displayed.

The depth number is dynamic, so additional variables such as the following can also be used:

```powershell
$TreeDepth3 = @(
    "some-directory"
)

$TreeDepth5 = @(
    "another-directory"
)
```

No changes to `ctree.ps1` are required.

---

# coutline

`coutline` analyzes Python source code and displays its structural hierarchy.

It uses Python's built-in `ast` module rather than searching the source code with regular expressions.

This allows the script to understand Python syntax more reliably.

## Usage

```powershell
coutline .\models.py
```

or:

```powershell
.\coutline.ps1 .\models.py
```

Example Python code:

```python
class User:

    def login(self):
        pass

    def logout(self):
        pass


class UserService:

    def create_user(self):
        pass


def health_check():
    pass
```

The output is:

```text
models.py
├── class User
│   ├── login()
│   └── logout()
├── class UserService
│   └── create_user()
└── health_check()
```

---

## AST-Based Analysis

`coutline` uses Python's Abstract Syntax Tree (AST).

The source code:

```python
class User:

    def login(self):
        pass
```

is parsed by Python into an AST containing nodes such as:

```text
Module
└── ClassDef
    └── FunctionDef
```

The analyzer uses these AST nodes to identify:

- Classes
- Functions
- Async functions
- Class methods
- Nested structures

This is more reliable than simply searching for strings such as:

```text
class
def
async def
```

---

## Running with uv

`coutline.ps1` runs the Python analyzer through `uv`:

```powershell
uv run python coutline.py ...
```

For example:

```powershell
coutline .\models.py
```

This allows the project Python environment to be used without manually activating `.venv`.

If `.venv` is currently active, the activation state is preserved.

If `.venv` is not active, `coutline` does not activate it permanently.

---

# cenv

`cenv` displays information about the current development environment.

## Usage

```powershell
cenv
```

or:

```powershell
.\cenv.ps1
```

Example output:

```text
Project
-------
Root: D:\WorkSpace\test\myproject

Operating System
----------------
Name: Microsoft Windows 11 Pro
Version: 10.0.26200
Architecture: 64-bit

PowerShell
----------
Version: 5.1.26100.9444
Edition: Desktop

Python
------
System:
  Status: Windows App Execution Alias
  Command: C:\Users\user\AppData\Local\Microsoft\WindowsApps\python.exe

Virtual Environment:
  Path: D:\WorkSpace\test\myproject\.venv\Scripts\python.exe
  Version: Python 3.13.x
  Active: No

uv
--
Status: Available
Command: C:\Users\user\.local\bin\uv.exe
Version: uv 0.x.x
Project Python: Python 3.13.x

Development Tools
-----------------
git : git version 2.x.x
```

---

## Python Detection

`cenv` distinguishes between an actual Python installation and the Windows App Execution Alias.

For example:

```text
C:\Users\user\AppData\Local\Microsoft\WindowsApps\python.exe
```

is recognized as:

```text
Status: Windows App Execution Alias
```

rather than being reported as a valid Python installation.

This prevents the Microsoft Store alias from being incorrectly reported as the system Python.

---

## Virtual Environment Detection

`cenv` directly checks:

```text
.venv\Scripts\python.exe
```

inside the project.

This means the project's Python version can be displayed even when the virtual environment is not currently activated.

For example:

```text
Virtual Environment:
  Path: D:\WorkSpace\test\myproject\.venv\Scripts\python.exe
  Version: Python 3.13.x
  Active: No
```

The `Active` value indicates whether the current PowerShell session has the virtual environment activated.

---

## uv Project Python

`cenv` also checks the Python environment used by `uv`:

```powershell
uv run python --version
```

This provides an additional way to verify the Python version configured for the project.

Example:

```text
uv
--
Status: Available
Command: C:\Users\user\.local\bin\uv.exe
Version: uv 0.x.x
Project Python: Python 3.13.x
```

---

# Recommended Workflow

These scripts can be used together when documenting a project.

## 1. Check the Environment

Run:

```powershell
cenv
```

This confirms the tools and Python environment being used.

---

## 2. Display the Project Structure

Run:

```powershell
ctree
```

This provides an overview of the project's files and directories.

---

## 3. Analyze Python Source Code

Run:

```powershell
coutline .\models.py
```

This provides a structural overview of the Python code.

---

# Example Documentation Workflow

For a Python or Django project, the three commands can be used as follows:

```powershell
cenv
```

```powershell
ctree
```

```powershell
coutline .\app\models.py
```

The resulting information can then be used in technical documentation or a blog post.

For example:

```text
Development Environment
        ↓
      cenv
        ↓
Project Directory
        ↓
      ctree
        ↓
Source Code Structure
        ↓
    coutline
```

This separates three different aspects of project documentation:

- **Environment** — What tools and versions are being used?
- **Project Structure** — How are files and directories organized?
- **Code Structure** — What classes and functions exist?

---

# Design Goals

The scripts are designed around several principles.

## Single Configuration

Project-specific settings are maintained in:

```text
config.ps1
```

rather than being duplicated across multiple scripts.

## Minimal Dependencies

`ctree` and `cenv` use PowerShell functionality.

`coutline` uses Python's standard-library `ast` module.

No additional Python package is required for code analysis.

## Non-Invasive Environment Handling

The scripts should inspect the development environment without permanently changing the current PowerShell session.

In particular, `coutline` uses `uv run` rather than manually activating and deactivating a virtual environment.

## Documentation-Oriented Output

The output is intended to be easy to copy into:

- README files
- Blog posts
- Technical documentation
- Tutorials
- Project reports
- Development notes

---
