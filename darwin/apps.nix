{pkgs, ...}: {
  # zsh is the default shell on Mac and we want to make sure that we're
  # configuring the rc correctly with nix-darwin paths.
  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
  '';

  environment.shells = with pkgs; [zsh];
  environment.systemPackages = with pkgs; [
    git
  ];

  # NOTE: install homebrew beforehand
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      # cleanup = "zap";
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask-versions"
    ];

    # `brew install`
    brews = [
      # TODO: maybe some of them are available with environment.systemPackages
      "bat"
      # TODO: docker
      # "docker"
      # "docker-completion"
      # "docker-compose"
      # "docker-machine"
      "exa"
      "go"
      "htop"
      "lima"
      "neovim"
      "lua"
      "qemu"
      "stow"
      "tmux"
      "zoxide"
      "zsh"
    ];

    # `brew install --cask`
    casks = [
      "arc"
      "mos"
      "stats"
      "iterm2"
      "raycast"
      "google-chrome"
    ];
  };
}
