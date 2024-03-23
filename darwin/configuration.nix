{systemSettings, ...}: {
  # TODO: hostname; https://github.com/ryan4yin/nix-darwin-kickstarter
  # networking.hostName = hostname;
  # networking.computerName = hostname;
  # system.defaults.smb.NetBIOSName = hostname;
  #
  # users.users."${username}"= {
  #   home = "/Users/${username}";
  #   description = username;
  # };
  #
  # nix.settings.trusted-users = [ username ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = systemSettings.stateVersion;
}
