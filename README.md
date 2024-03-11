# nixos-config

A command to apply configs in NixOS.
It's currently not working but one day I'll fix it.

```bash
nix-shell -p git --command "nix run github:a2not/nixos-config --extra-experimental-features nix-command --extra-experimental-features flakes"
```

ref: https://github.com/librephoenix/nixos-config/blob/main/install.org

## system build

```bash
sudo nixos-rebuild switch --flake .#system
```

## home-manager

```bash
nix run home-manager/master -- switch --flake .#user
```
