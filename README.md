# GitHub Research Security Workflows

This repository provides reusable GitHub workflows and pre-commit hooks designed to help research teams prevent accidental data leaks, enforce version control standards, and comply with institutional security guidelines.

It is part of a broader effort to support researchers in securely managing software and data when working with GitHub.

## Contents

### Reusable GitHub Workflow

- `.github/workflows/check-forbidden-filetypes.yml`  
  A reusable workflow that fails if forbidden file types are committed. It uses the composite github action `filetype-check/` as suggested by GitHub security guidelines. It can be called from other workflows in the organization. For usage see below.

### Composite GitHub Action

- `filetype-check/`  
  A composite GitHub Action that scans the Git index for forbidden file extensions. It reads from a shared `forbidden-extensions.txt` file. Used by check-forbidden-filetypes workflow

### Pre-commit Hook

- `pre-commit-check/check-filetypes.sh`  
  A shell-based pre-commit hook to block commits that include forbidden file types. Also uses the shared extension list.

### Shared Extension List

- `forbidden-extensions.txt`  
  A centralized list of sensitive file extensions (e.g. `.csv`, `.json`, `.nii.gz`) used by both the action and the pre-commit hook.

## Usage

### Using the GitHub Workflow in a Repository

To use the reusable workflow in another repository, create a workflow file like this:

```yaml
name: Check for forbidden filetypes

on:
  push:
    branches: [main]
  pull_request:

jobs:
  security-check:
    uses: bavadeve/org-security-workflows/.github/workflows/check-forbidden-filetypes.yml@main
```

Replace `@main` with a version tag for stability if available.

### Using the Pre-commit Hook

In your repository's `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/bavadeve/org-security-workflows
    rev: main
    hooks:
      - id: check-forbidden-filetypes

repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-added-large-files
        args: ['--maxkb=100']
      - id: check-merge-conflict
```

Then install the hook:

```bash
pre-commit install
```

This ensures commits are checked locally before being pushed.

## Notes for Windows / GitHub Desktop Users

On Windows, pre-commit hooks will not run correctly in default GitHub Desktop shell environments. To enable proper behavior:

1. Install Git Bash (from https://gitforwindows.org/)
2. In GitHub Desktop: File → Options → Git → Shell → select "Git Bash"

Alternatively, use Git Bash or WSL directly for committing.

## Security Layers

| Layer              | Purpose                                               | Limitations                                      |
|-------------------|--------------------------------------------------------|--------------------------------------------------|
| `.gitignore`       | Prevents common sensitive files from being tracked     | Can be bypassed with `git add -f`                |
| Pre-commit hook   | Blocks dangerous files from being committed locally     | Requires local setup, can be skipped             |
| GitHub Action     | Catches violations on push or PR                        | Cannot block direct pushes unless protected      |
| Branch protection | Prevents merging PRs that fail security checks          | Must be configured per repository                |

These layers provide increasing levels of safety, from developer machines to repository-level enforcement.

## License

This project is licensed under the MIT License.
