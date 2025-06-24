import requests

# URL to your central forbidden extension list
EXT_URL = "https://raw.githubusercontent.com/bavadeve/org-security-workflows/main/forbidden-extensions.txt"


def fetch_forbidden_extensions():
    response = requests.get(EXT_URL)
    response.raise_for_status()
    return response.text.splitlines()


def generate_gitignore(extensions):
    lines = [
        "# Auto-generated from forbidden-extensions.txt",
        "# Do not edit this section manually. Edit the central file instead.",
        "",
    ]
    for ext in extensions:
        ext = ext.strip()
        if not ext or ext.startswith("#"):
            continue
        lines.append(f"*.{ext}")
    return "\n".join(lines)


if __name__ == "__main__":
    extensions = fetch_forbidden_extensions()
    gitignore = generate_gitignore(extensions)

    with open(".gitignore", "w") as f:
        f.write(gitignore)

    print("✅ .gitignore file generated based on forbidden-extensions.txt")
