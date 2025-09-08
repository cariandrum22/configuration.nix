{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "op" ''
      #!/usr/bin/env bash
      # Wrapper: invoke Windows 1Password CLI (op.exe) from WSL
      # Notes:
      # - Prefer WinGet Links location if present.
      # - On drvfs, ".exe" may not have +x; use "-f" instead of "-x".
      # Style: Google Shell Style + ShellCheck-friendly
      set -euo pipefail
      IFS=$'\n\t'

      die() {
        printf '%s\n' "ERROR: $*" >&2
        exit 1
      }

      have() { command -v "''$1" >/dev/null 2>&1; }

      read_win_env() {
        # Usage: read_win_env VAR_NAME
        # Reads a Windows environment variable via cmd.exe without CR.
        local name value
        name="''$1"
        value=$(/mnt/c/Windows/System32/cmd.exe /C "echo %''${name}%" 2>/dev/null | tr -d '\r')
        # cmd.exe echoes the literal if undefined; detect that case.
        [[ "''${value}" == "%''${name}%" || -z "''${value}" ]] && return 1
        printf '%s' "''${value}"
      }

      resolve_localappdata_path() {
        # Resolve LOCALAPPDATA and convert to WSL path.
        local lad lad_wsl
        lad="$(read_win_env LOCALAPPDATA)" || return 1
        lad_wsl="$(wslpath -u "''${lad}")"
        printf '%s' "''${lad_wsl}"
      }

      candidate_paths() {
        # Generate possible locations for op.exe (most specific first).
        # 0) Explicit override via env.
        if [[ -n "''${OP_WINDOWS_EXE:-}" ]]; then
          printf '%s\n' "''${OP_WINDOWS_EXE}"
        fi

        # 1) WinGet shim path: %LOCALAPPDATA%\Microsoft\WinGet\Links\op.exe
        local lad
        if lad="$(resolve_localappdata_path)"; then
          printf '%s\n' "''${lad}/Microsoft/WinGet/Links/op.exe"
        fi

        # 2) Standard per-user installs under LOCALAPPDATA.
        if [[ -n "''${lad:-}" ]]; then
          printf '%s\n' "''${lad}/1Password/op.exe"
          printf '%s\n' "''${lad}/1Password CLI/op.exe"
          printf '%s\n' "''${lad}/Programs/1Password/op.exe"
          # Extra fallback: scan app subfolders if present (bounded depth).
          if have find; then
            find "''${lad}" -maxdepth 4 -type f -name 'op.exe' 2>/dev/null || true
          fi
        fi

        # 3) Per-user path via USERNAME (in case LOCALAPPDATA failed).
        local user
        if user="$(read_win_env USERNAME)"; then
          printf '%s\n' "/mnt/c/Users/''${user}/AppData/Local/Microsoft/WinGet/Links/op.exe"
          printf '%s\n' "/mnt/c/Users/''${user}/AppData/Local/1Password/op.exe"
          printf '%s\n' "/mnt/c/Users/''${user}/AppData/Local/1Password CLI/op.exe"
          printf '%s\n' "/mnt/c/Users/''${user}/AppData/Local/Programs/1Password/op.exe"
        fi

        # 4) Machine-wide fallbacks.
        printf '%s\n' "/mnt/c/Program Files/1Password/op.exe"
        printf '%s\n' "/mnt/c/Program Files/1Password CLI/op.exe"
      }

      find_op_exe() {
        # Pick the first existing op.exe from candidates.
        local p
        while IFS= read -r p; do
          [[ -n "''${p}" && -f "''${p}" ]] && { printf '%s' "''${p}"; return 0; }
        done < <(candidate_paths)
        return 1
      }

      sanity_checks() {
        # Ensure required tools are available.
        have wslpath || die "wslpath not found. Enable interop and ensure WSL tools are available."
        [[ -f /mnt/c/Windows/System32/cmd.exe ]] || die "cmd.exe not reachable at /mnt/c/Windows/System32/cmd.exe"
      }

      main() {
        sanity_checks
        local op_exe
        op_exe="$(find_op_exe)" || die "op.exe not found. Install 1Password CLI or set OP_WINDOWS_EXE."
        exec "''${op_exe}" "''$@"
      }

      main "''$@"
    '')
  ];
}
