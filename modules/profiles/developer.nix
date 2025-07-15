{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.profiles.developer;
in
{
  options.modules.profiles.developer = {
    enable = mkEnableOption "developer profile";

    languages = mkOption {
      type = types.listOf (
        types.enum [
          "c"
          "rust"
          "python"
          "javascript"
          "go"
          "nix"
        ]
      );
      default = [ "c" ];
      description = "Programming languages to include development tools for";
    };

    editor = mkOption {
      type = types.enum [
        "emacs"
        "vim"
        "neovim"
        "vscode"
        "none"
      ];
      default = "none";
      description = "Primary editor to use";
    };

    enableContainers = mkOption {
      type = types.bool;
      default = false;
      description = "Enable container development tools";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional packages to include in developer profile";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        # Core development tools
        git
        gnumake
        gcc
        gdb
        pkg-config
        cmake
        autoconf
        automake
        libtool

        # Build essentials
        binutils
        patchelf

        # Libraries
        zlib
        openssl

        # Text processing
        jq
        yq
        ripgrep
        fd
        bat
        delta

        # Network debugging
        curl
        wget
        httpie
        netcat
        dnsutils

        # System debugging
        strace
        ltrace
        lsof
        htop
        btop

        # Version control
        gh
        git-lfs
      ]
      # Language-specific tools
      ++ (optionals (elem "c" cfg.languages) [
        clang
        clang-tools
        llvmPackages.libstdcxxClang
        valgrind
        glibc.dev
      ])
      ++ (optionals (elem "rust" cfg.languages) [
        rustc
        cargo
        rustfmt
        clippy
        rust-analyzer
      ])
      ++ (optionals (elem "python" cfg.languages) [
        python3
        python3Packages.pip
        python3Packages.virtualenv
        python3Packages.ipython
        python3Packages.black
        python3Packages.pylint
        python3Packages.mypy
      ])
      ++ (optionals (elem "javascript" cfg.languages) [
        nodejs
        nodePackages.npm
        nodePackages.yarn
        nodePackages.typescript
        nodePackages.prettier
        nodePackages.eslint
      ])
      ++ (optionals (elem "go" cfg.languages) [
        go
        gopls
        golangci-lint
      ])
      ++ (optionals (elem "nix" cfg.languages) [
        nil
        nixfmt-rfc-style
        nix-prefetch-scripts
        nix-tree
        nix-diff
      ])
      # Editor
      ++ (optional (cfg.editor == "emacs") emacs)
      ++ (optional (cfg.editor == "vim") vim)
      ++ (optional (cfg.editor == "neovim") neovim)
      ++ (optional (cfg.editor == "vscode") vscode)
      # Container tools
      ++ (optionals cfg.enableContainers [
        podman
        buildah
        skopeo
      ])
      # Extra packages
      ++ cfg.extraPackages;

    # Enable documentation
    documentation.dev.enable = true;

    # Shell configuration for development
    programs.bash.shellAliases = {
      ll = "ls -la";
      la = "ls -a";
      l = "ls -l";
      g = "git";
      gc = "git commit";
      gs = "git status";
      gd = "git diff";
      gl = "git log";
    };
  };
}
