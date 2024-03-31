darwin_hostname := "your-hostname"


update:
  nix flake update

history:
  nix profile history --profile /nix/var/nix/profiles/system

gc:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
  sudo nix store gc --debug

fmt:
  nix fmt

clean:
  rm -rf result

build-system:
  sudo nixos-rebuild switch --flake .#system

build-home:
  nix run home-manager/master -- switch --flake .#user

darwin:
  nix build .#darwinConfigurations.${darwin_hostname}.system --extra-experimental-features 'nix-command flakes'
  ./result/sw/bin/darwin-rebuild switch --flake .#${darwin_hostname}

darwin-debug:
  nix build .#darwinConfigurations.${darwin_hostname}.system --show-trace --verbose --extra-experimental-features 'nix-command flakes'
  ./result/sw/bin/darwin-rebuild switch --flake .#${darwin_hostname} --show-trace --verbose
