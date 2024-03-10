{ pkgs, inputs, ... }:
{
# Add ~/.local/bin to PATH
  environment.localBinInPath = true;

# programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      vim = "nvim";
      l = "exa -lah --icons";
      ls = "exa --icons";
      sl = "exa --icons";
      docker-compose = "docker compose";

      rebuild = "sudo nixos-rebuild switch";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
          "zsh-autosuggestions"
          "zsh-syntax-highlighting"
      ];
    };
  };

  users.users.a2not = {
    isNormalUser = true;
    home = "/home/a2not";
    createHome = true;
    extraGroups = [ "wheel" ]; # TODO:docker
    shell = pkgs.zsh;
  };

# pkgs
  environment.systemPackages = with pkgs; [
    neovim
      zsh
      tmux
      git
      delta
      htop
      bat
      exa
      ripgrep
      zoxide
      jq
      starship

      go
      rustup
  ];
}

