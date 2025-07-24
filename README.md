# configuration.nix

[![CI](https://github.com/cariandrum22/configuration.nix/actions/workflows/ci.yml/badge.svg)][ci]

[ci]: https://github.com/cariandrum22/configuration.nix/actions/workflows/ci.yml

A NixOS configuration managed with Nix Flakes.

## System Requirements

- NixOS with flakes enabled
- Git for version control

## Installation

Clone the repository and build the system configuration:

```shell
git clone https://github.com/cariandrum22/configuration.nix
cd configuration.nix
sudo nixos-rebuild switch --flake .#<hostname> --impure
```

Replace `<hostname>` with your actual host configuration name.

Note: The `--impure` flag is required as the configuration dynamically imports
`/etc/nixos/hardware-configuration.nix` when available.

## Development

### Setting Up Development Environment

Enter the development shell to access all necessary tools:

```shell
nix develop
```

This provides:

- nil (Nix Language Server for IDE integration)
- Pre-commit hooks for code quality

### Pre-commit Hooks

This project uses pre-commit hooks to maintain code quality. The following checks run automatically:

**Nix files:**

- nixfmt-rfc-style: Formats code according to RFC-166
- deadnix: Detects unused bindings and imports
- statix: Identifies anti-patterns and suggests improvements

**Markdown files:**

- markdownlint: Enforces consistent style
- prettier: Formats Markdown files

**YAML files:**

- yamllint: Validates YAML syntax and style
- prettier: Formats YAML files

**GitHub Actions:**

- actionlint: Validates workflow syntax, detects type errors, and security issues

**Commit messages:**

- commitizen: Enforces Conventional Commits format

### Commit Message Format

All commits must follow the Conventional Commits specification:

```text
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

Common types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Example:

```text
feat: add Nordic theme support

- Configure GTK and Qt themes
- Add theme toggle script
```

### Manual Checks

Run all checks manually:

```shell
nix develop -c pre-commit run --all-files
```

### Testing GitHub Actions Locally

Test GitHub Actions workflows locally using act:

```shell
nix develop -c act -l  # List available workflows
nix develop -c act     # Run default push event workflows
nix develop -c act -j flake-check  # Run specific job
```

## Continuous Integration

This repository uses GitHub Actions for automated testing:

- **Flake Check**: Validates the flake configuration
- **Lint**: Runs all pre-commit hooks on the codebase
- **Build**: Tests building NixOS configurations
- **Format Check**: Verifies code formatting

All checks run on pull requests and pushes to the main branch. The CI uses Nix caching for faster
builds.

### Dependency Updates

**Nix flake inputs** are automatically updated weekly via automated PR workflow.

To manually update flake dependencies:

```shell
nix flake update
```
