{pkgs, ...}: {
  # programs.zsh.enableCompletion
  environment.pathsToLink = ["/share/zsh"];

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
}
