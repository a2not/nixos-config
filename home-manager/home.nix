# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  systemSettings,
  userSettings,
  ...
}: {
  imports = [
    ./zsh/default.nix
    ./neovim/default.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = userSettings.username;
    homeDirectory = "/home/" + userSettings.username;
  };

  # pkgs
  home.packages = with pkgs; [
    tmux
    git
    delta
    htop
    bat
    eza
    ripgrep
    zoxide
    jq
    starship

    go
    rustup
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.sessionVariables = {
    EDITOR = userSettings.editor;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = systemSettings.stateVersion;
}
