#!/bin/bash


#check if nix is installed
nix-env --version 
read NIX

#if nix is installed then continue, else exit the script
if [ NIX = "*" ]; then do;
    break;;
else
    echo "Nix is not installed"
    echo "Please install nix and try again"
    exit;;
fi


#make the dir for enabling features
mkdir -p ~/.config/nix

#enable flakes and nix profile feature
cat <<EOF >> ~/.config/nix/nix.conf
experimental-features = nix-command flakes
experimental-features = nix-command profile
EOF

#restart nix deamon
sudo launchctl kickstart -k system/org.nixos.nix-daemon

#make the dir to store our configs
mkdir -p ~/.config/nixpkgs && cd ~/.config/nixpkgs

cat <<EOF > ~/.config/nixpkgs/flake.nix
{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: let
    arch = "x86_64";;
  in {
    defaultPackage.${arch} =
      home-manager.defaultPackage.${arch};

    homeConfigurations.YOUR_USER = avie6
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${arch};
        modules = [ ./home.nix ];
      };
    };
}
EOF


git init && git add .
sleep 2
nix run . switch
sleep 5
cp -L ~/.gitconfig gitconfig