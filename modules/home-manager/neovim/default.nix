{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;

    extraPackages = with pkgs; [ripgrep];
  };
}
