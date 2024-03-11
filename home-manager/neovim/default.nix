{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;

    extraPackages = with pkgs; [ripgrep];

    # TODO: copy config file so that neovim can be configured without nix syntax
    # xdg.configFile
  };
}
