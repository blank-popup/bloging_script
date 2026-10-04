import ast
import sys
from pathlib import Path


def get_definitions(node):
    """Return classes and functions directly defined in a node."""
    definitions = []

    for child in node.body:
        if isinstance(
            child,
            (ast.ClassDef, ast.FunctionDef, ast.AsyncFunctionDef),
        ):
            definitions.append(child)

    return definitions


def get_label(node):
    """Create a display label for an AST node."""
    if isinstance(node, ast.ClassDef):
        return f"class {node.name}"

    if isinstance(node, ast.AsyncFunctionDef):
        return f"async def {node.name}()"

    if isinstance(node, ast.FunctionDef):
        return f"def {node.name}()"

    return node.__class__.__name__


def print_outline(node, prefix=""):
    """Print definitions as a tree."""
    definitions = get_definitions(node)

    for index, child in enumerate(definitions):
        is_last = index == len(definitions) - 1

        branch = "└── " if is_last else "├── "
        print(f"{prefix}{branch}{get_label(child)}")

        if isinstance(child, ast.ClassDef):
            next_prefix = prefix + (
                "    " if is_last else "│   "
            )
            print_outline(child, next_prefix)


def process_file(file_path):
    path = Path(file_path)

    try:
        source = path.read_text(encoding="utf-8-sig")
        tree = ast.parse(source, filename=str(path))
    except (OSError, SyntaxError, UnicodeError) as error:
        print(f"{path}: {error}", file=sys.stderr)
        return

    print(path.name)
    print_outline(tree)
    print()


def main():
    target = Path(sys.argv[1] if len(sys.argv) > 1 else ".")

    if target.is_file():
        if target.suffix == ".py":
            process_file(target)
        else:
            print(f"Not a Python file: {target}", file=sys.stderr)
        return

    if not target.is_dir():
        print(f"Path not found: {target}", file=sys.stderr)
        return

    excluded = {".git", ".venv", "__pycache__"}

    for path in sorted(target.rglob("*.py")):
        if any(part in excluded for part in path.parts):
            continue

        process_file(path)


if __name__ == "__main__":
    main()
