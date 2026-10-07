**# Project Documentation Scripts**



A collection of PowerShell and Python scripts for quickly documenting and inspecting a software project.



The scripts are designed for use in a development project and are especially useful when creating technical documentation, blog posts, tutorials, or project overviews.



**## Features**

This project provides four main commands:

| Command | Purpose |
|---|---|
| `ctree` | Display the project directory structure |
| `coutline` | Display the structure of Python source code |
| `cenv` | Display the development environment information |
| `czip` | Compress the project while excluding specified files and directories |

All scripts share a single configuration file:



```text

config.ps1

```



This allows project-specific settings to be managed in one place.



**---**



**# Directory Structure**



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
├── czip.ps1
├── pyproject.toml
├── .venv/
└── ...
```



**---**



**# Requirements**



**## PowerShell**



The scripts are compatible with ****Windows PowerShell 5.1****.



They do not require PowerShell 7.



**## Python**



Python is required for `coutline`.



The Python source analyzer uses the standard library `ast` module, so no additional Python packages are required.



**## uv**



`coutline` uses `uv run` to execute the Python analyzer.



Therefore, `uv` should be installed and available in `PATH`.



**## Git**



Git is optional.



If Git is installed, `cenv` displays the installed Git version.



**---**



**# Configuration**



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



**---**



**# ctree**



`ctree` displays the directory structure of the current project in a tree format.



**## Usage**



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
│   ├── Include/
│   ├── Lib/
│   └── Scripts/
├── config/
│   ├── settings.py
│   └── urls.py
└── app/
    ├── __init__.py
    ├── models.py
    ├── views.py
    └── serializers.py
```



**## Excluding Directories**



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



**---**



**## Directory Depth Rules**



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



**### Depth 0**



```powershell

$TreeDepth0 = @(

    ".venv"

)

```



Only the directory itself is displayed.



**### Depth 1**



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



**### Depth 2**



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



**---**



**# coutline**



`coutline` analyzes Python source code and displays its structural hierarchy.



It uses Python's built-in `ast` module rather than searching the source code with regular expressions.



This allows the script to understand Python syntax more reliably.



**## Usage**



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
│   ├── login()
│   └── logout()
├── class UserService
│   └── create_user()
└── health_check()
```



**---**



**## AST-Based Analysis**



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



**---**



**## Running with uv**



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



**---**



**# cenv**



`cenv` displays information about the current development environment.



**## Usage**



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



**---**



**## Python Detection**



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



**---**



**## Virtual Environment Detection**



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



**---**



**## uv Project Python**



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



**---**



**# czip**

`czip` creates a ZIP archive of the current project while excluding files and directories that are not useful for source-code distribution, documentation, or backup.

This is particularly useful for Python and Django projects that contain large or generated directories such as `.venv`, `.git`, and `__pycache__`.

**## Usage**

Run the command from the project root:

```powershell

czip

```

or:

```powershell

.\czip.ps1

```

By default, the ZIP file is created in the parent directory of the current project.

For example:

```text

D:\WorkSpace\project\ahaapi

D:\WorkSpace\project\ahaapi.zip

```

**## Output File Name**

A different output file name can be specified with the `-Output` option:

```powershell

czip -Output "ahaapi-2026-10-08.zip"

```

or:

```powershell

.\czip.ps1 -Output "backup.zip"

```

**## Excluded Directories**

The default configuration excludes directories that normally should not be included in a project archive:

```powershell

$ExcludeDirectories = @(
    ".venv",
    ".git",
    "__pycache__",
    ".pytest_cache",
    ".ruff_cache",
    ".mypy_cache",
    "node_modules",
    "dist",
    "build"
)
```

These exclusions are especially useful for Django and uv projects.

For example, `.venv` contains the project's virtual environment and can usually be recreated from `pyproject.toml` and `uv.lock`, so including it in the archive is unnecessary.

`.git` contains Git repository metadata and is normally not required when sharing a source-code archive.

Python cache and test/tool cache directories are also excluded because they can be regenerated.

**## Excluded Files**

Individual files can also be excluded:

```powershell

$ExcludeFiles = @(
    "*.pyc",
    "*.pyo",
    "*.log",
    ".DS_Store"
)
```

Additional patterns can be added when required:

```powershell

$ExcludeFiles = @(
    "*.pyc",
    "*.pyo",
    "*.log",
    "*.tmp",
    "*.bak",
    ".DS_Store"
)
```

**## Django and uv Project Example**

For a project such as:

```text
ahaapi/
├── .git/
├── .venv/
├── config/
├── src/
│   └── ahaapi/
│       ├── api/
│       └── users/
├── manage.py
├── pyproject.toml
├── uv.lock
└── README.md
```

running:

```powershell

czip

```

creates an archive containing the source and project configuration while excluding generated or local-only directories.

The resulting archive is conceptually:

```text
ahaapi.zip
└── ahaapi/
    ├── config/
    ├── src/
    │   └── ahaapi/
    │       ├── api/
    │       └── users/
    ├── manage.py
    ├── pyproject.toml
    ├── uv.lock
    └── README.md
```

The `.venv`, `.git`, Python cache directories, and other configured exclusions are not included.

**## Configuration**

The exclusion lists are defined near the beginning of `czip.ps1`, so they can be changed without modifying the compression logic.

```powershell

$ExcludeDirectories = @(
    ".venv",
    ".git",
    "__pycache__"
)

$ExcludeFiles = @(
    "*.pyc",
    "*.log"
)

```

This makes `czip` suitable for different project types without requiring a separate compression script for each project.

**## Archive Design**

`czip` first collects the files that are allowed by the exclusion rules, copies them to a temporary directory, and creates the ZIP archive from that temporary project directory.

The temporary directory is removed after compression is completed.

The output ZIP file itself is also excluded from the input files, preventing the archive from being included inside itself when an existing output file is present.


**## Existing ZIP File**

If the output ZIP file already exists, `czip` asks whether it should be overwritten.

```text
ZIP file already exists:
D:\WorkSpace\django\ahaapi.zip

Overwrite? (Y/N):
```

Only `Y` or `y` continues the compression process. The existing ZIP file is deleted before the new archive is created.

Any other input, including `N`, `n`, or an empty input, cancels the compression.

This prevents an existing archive from being overwritten accidentally.

**---**

**# Recommended Workflow**



These scripts can be used together when documenting a project.



**## 1. Check the Environment**



Run:



```powershell

cenv

```



This confirms the tools and Python environment being used.



**---**



**## 2. Display the Project Structure**



Run:



```powershell

ctree

```



This provides an overview of the project's files and directories.



**---**



**## 3. Analyze Python Source Code**



Run:



```powershell

coutline .\models.py

```



This provides a structural overview of the Python code.



**---**



**# Example Documentation Workflow**



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



- ****Environment**** — What tools and versions are being used?

- ****Project Structure**** — How are files and directories organized?

- ****Code Structure**** — What classes and functions exist?



**---**



**# Design Goals**



The scripts are designed around several principles.



**## Single Configuration**



Project-specific settings are maintained in:



```text

config.ps1

```



rather than being duplicated across multiple scripts.



**## Minimal Dependencies**



`ctree` and `cenv` use PowerShell functionality.



`coutline` uses Python's standard-library `ast` module.



No additional Python package is required for code analysis.



**## Non-Invasive Environment Handling**



The scripts should inspect the development environment without permanently changing the current PowerShell session.



In particular, `coutline` uses `uv run` rather than manually activating and deactivating a virtual environment.



**## Documentation-Oriented Output**



The output is intended to be easy to copy into:



- README files

- Blog posts

- Technical documentation

- Tutorials

- Project reports

- Development notes



**---**



**# Git Initial Setup and GitHub Repository Configuration**



The following commands configure Git user information, set the commit message template, rename the default branch, connect the local repository to GitHub, and push the repository to the remote server.



**## 1. Configure the Commit Message Template**



Set `.gitmessage.txt` as the commit message template:



```powershell

git config commit.template .gitmessage.txt

```



To check the configured template:



```powershell

git config commit.template

```



**## 2. Configure User Information**



Set the name and email address used for Git commits:



```powershell

git config user.email "useremail\@example.com"

git config user.name "username"

```



Check the configured values:



```powershell

git config user.email

git config user.name

```



**## 3. Rename the Default Branch**



Rename the current branch to `master`:



```powershell

git branch -M master

```



> `main` is also commonly used as the default branch name. Use the branch name that matches your project or repository convention.



**## 4. Add the GitHub Remote Repository**



Connect the local repository to the GitHub repository:



```powershell

git remote add origin https://github.com/id/repository.git

```



Check the configured remote:



```powershell

git remote -v

```



**## 5. Push the Local Repository to GitHub**



Push the `master` branch to GitHub and set it as the upstream branch:



```powershell

git push -u origin master

```



After the upstream branch has been configured, subsequent pushes can usually be performed with:



```powershell

git push

```



**## Complete Example**



```powershell

# Commit message template

git config commit.template .gitmessage.txt



# Check the commit message template

git config commit.template



# Git user information

git config user.email "useremail\@example.com"

git config user.name "username"



# Rename the current branch

git branch -M master



# Add the GitHub remote repository

git remote add origin https://github.com/id/repository.git



# Push the repository to GitHub

git push -u origin master

```
