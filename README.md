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
sudo nixos-rebuild switch --flake .#<hostname>
```

Replace `<hostname>` with `eto`, `chetter`, or `virgil`.

The checked-in hardware configurations allow pure evaluation; `--impure` is not needed for these
hosts. Review the hardware configuration before deploying to a different machine.

## Development

### Setting Up Development Environment

Enter the development shell to access all necessary tools:

```shell
nix develop
```

This provides:

- nil (Nix Language Server for IDE integration)
- Pre-commit hooks for code quality

The shell and CI use the same locked pre-commit runner. Re-enter `nix develop` after updating
`flake.lock` or hook configuration to refresh the installed Git hooks.

### Pre-commit Hooks

This project uses pre-commit hooks to maintain code quality. File checks run before commits;
Commitizen runs separately at the `commit-msg` stage.

**Nix files:**

- nixfmt: Formats Nix code using the standard formatter (formerly `nixfmt-rfc-style`)
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

Evaluate every supported system, then build the native x86_64 lint and secret checks as CI does:

```shell
nix flake check --all-systems --no-build --no-update-lock-file
nix build --no-link --no-update-lock-file \
  .#checks.x86_64-linux.pre-commit-check \
  .#checks.x86_64-linux.chetter-sops-manifest
```

The SOPS manifest check validates secret key paths in the encrypted files without private keys or
decryption. It does not test whether the target host can decrypt the secrets.

Plan a host build, then do a full build before deploying:

```shell
nix build --dry-run --no-update-lock-file .#nixosConfigurations.chetter.config.system.build.toplevel
nixos-rebuild build --flake .#chetter
```

### Testing GitHub Actions Locally

Test GitHub Actions workflows locally using act:

```shell
nix develop -c act -l  # List available workflows
nix develop -c act     # Run default push event workflows
nix develop -c act -j check-flake  # Run specific job
```

## Continuous Integration

This repository uses GitHub Actions for automated testing:

- **Flake Check**: Pure evaluation of all hosts and both supported Linux architectures' flake
  outputs
- **Lint and Secret Validation**: Builds file lint/format checks and chetter's SOPS manifest
- **Build Plans**: Evaluates build plans for eto, chetter, and virgil without building the full
  systems

All checks run on pull requests and pushes to the main branch. New PR pushes cancel superseded runs;
running main-branch checks are not canceled. The CI uses Nix binary caches for dependencies, but is
not a full NixOS build or boot test. Commit message validation runs through the local `commit-msg`
hook.

### Dependency Updates

**Nix flake inputs** are automatically updated daily via automated PR workflow.

To manually update flake dependencies:

```shell
nix flake update
```

Update only one input with `nix flake update nixpkgs`. CI uses `--no-update-lock-file` to reject
unlocked input changes instead of silently resolving new dependencies.
