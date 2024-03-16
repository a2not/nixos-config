# nixos-config

## 🚧 [WIP] auto install
A command to apply configs in NixOS.
It's currently not working but one day I'll fix it.

```bash
nix-shell -p git --command "nix run github:a2not/nixos-config --extra-experimental-features 'nix-command flakes'"
```

ref: https://github.com/librephoenix/nixos-config/blob/main/install.org

ref: https://librephoenix.com/2024-03-14-managing-your-nixos-config-with-git#org9fe2aab

## manual install

```bash
git clone https://github.com/a2not/nixos-config.git ~/nixos-config
```

### system build

```bash
sudo nixos-generate-config --show-hardware-config > ~/nixos-config/nixos/hardware-configuration.nix
sudo nixos-rebuild switch --flake ~/nixos-config#system
```

### home-manager

```bash
nix run home-manager/master -- switch --flake ~/nixos-config#user
```

## useful commands

### check flake metadata

from: https://fasterthanli.me/series/building-a-rust-service-with-nix/part-10#a-flake-with-a-dev-shell

this comes in handy especially when wanting to check if we're properly setting `inputs.<some_package>.follows`.

```bash
nix flake metadata
```

### debug nix flake

from: https://nixos-and-flakes.thiscute.world/best-practices/debugging#debugging-derivations-and-nix-expressions

to debug the output (and/or inputs or everything in between) of the nix flake.

```bash
nix repl

# inside nix repl shell, load the flake in the current directory
nix-repl> :lf .

# press <TAB> to see what we have in scope
nix-repl><TAB>
nix-repl>inputs.<TAB>
nix-repl>outputs.<TAB>
```

