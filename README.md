# org-security-workflows

This repository provides reusable GitHub Actions workflows to help enforce organizational security policies.

## ✅ Available Workflows

### `check-forbidden-filetypes.yml`

Scans your repository for committed files with sensitive extensions (e.g., `.csv`, `.xlsx`, `.env`, `.RData`, etc.).

### 🔧 How to use in another repository

Add this to `.github/workflows/org-security.yml`:

```yaml
name: Org Security Scan

on:
  push:
    branches: [main, master]
  pull_request:
    branches: [main, master]

jobs:
  check:
    uses: bavadeve/org-security-workflows/.github/workflows/check-forbidden-filetypes.yml@main
