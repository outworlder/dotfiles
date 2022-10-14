{ config, pkgs, ... }:

let
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
  }) {
    doomPrivateDir = /Users/seilert/doom.d;  # Directory containing your config.el init.el
    # and packages.el files
  };
in {
  home.packages = with pkgs; [
    git
    aws-iam-authenticator
    doom-emacs
    emacs-all-the-icons-fonts
    gnutls
    binutils
    imagemagick
    gopls
    zstd
    nodePackages.javascript-typescript-langserver
    editorconfig-core-c
    (ripgrep.override { withPCRE2 = true; })
    sqlite
    terraform
    terragrunt
    pandoc
    delta
    kubernetes-helm
    htop
    neofetch
    openssh
    cargo
    awscli2
    saml2aws
    kubectl
    google-cloud-sdk
    docker-machine
    k9s
    nmap
    jq
    wget
    watch
    silver-searcher
    sops
    tree
    figlet
    nodejs
    backblaze-b2
    onefetch
    gitleaks
    teleport
    chicken
    logseq
  ];

  home.file.".emacs.d/init.el".text = ''
      (load "default.el")
  '';

  home.file.".emacs.d/config.el".text = ''
    (setq doom-font (font-spec :family "FuraCode Nerd Font" :size 24))
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "seilert";
  home.homeDirectory = "/Users/seilert";

  programs.emacs = {
    enable = false;
 };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    historyLimit = 100500;
    keyMode = "emacs";
    extraConfig = ''
          unbind C-Space
          set -g prefix C-Space
          bind C-Space send-prefix
          set -g status off
          '';
    plugins = [ pkgs.tmuxPlugins.yank ];
  };

  programs.git = {
    enable = true;
    userName = "Stephen Eilert";
      userEmail= "stephen.eilert@hpe.com";
  };

  programs.go = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      homeupdate = "home-manager switch";
    };
    initExtra = ''
      export EDITOR=emacsclient
      # Nix setup (environment variables, etc.)
      if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
      fi
      # Load environment variables from a file; this approach allows me to not
      # commit secrets like API keys to Git
      if [ -e ~/.env ]; then
        . ~/.env
      fi
    '';

    history = {
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      theme = "edvardm";
      plugins = [ "git" "cp" "aws" "kubectl"];
      custom = "$HOME/.oh-my-zsh-custom";
    };
    prezto = {
      enable = true;

      # Case insensitive completion
      caseSensitive = false;

      # Autoconvert .... to ../..
      editor.dotExpansion = true;

      # Prezto modules to load

      pmodules = [
        "utility"
        "completion"
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "syntax-highlighting"
        "history-substring-search"
      ];

    };

  };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
