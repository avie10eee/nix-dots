{ inputs, lib, config, pkgs, attrsets, ... }: {

  #imports
  imports = [ ./alacritty.nix ]; # imports alacritty.nix/ alacritty config



  #nixpkgs config
  nixpkgs = {
    config = {
      allowUnfree = true; # allow unfree
      allowUnfreePredicate = (_: true); # allow unfree
    };
  };



  #home config
  home = {
    username = "avie6";
    homeDirectory = "/home/avie6";
    programs.home-manager.enable = true;
    home.homeDirectory = /home/avie6;
    home.stateVersion = "22.11";
  };


  #programs
  programs = {
    git = {
          enable = true;
          includes = [{ path = "~/.config/nixpkgs/gitconfig"; }];
          userName = "Geller Software";
          userEmail = "avie10eee@gmail.com";
          signing.signByDefault = true;
          extraConfig = {
            hub.protocol = "https";
            github.user = "avie10eee";
          };
        };

    bat = {
      enable = true;
      theme = "ansi-dark";
    };

    zoxide = {
      enable = true;
    };

    firefox = {
      enable = true;
    };

    dircolors = {
      enable = true;
    };

    fzf = {
      enable = true;
    };

    alacritty = {
      enable = true;
      settings = lib.attrsets.recursiveUpdate (import ${HOME}/.config/nixpkgs/alacritty/alacritty.nix) {
        include = [{ path = "~/.config/nixpkgs/alacritty/alacritty.nix"; }];
        extraConfig = {
          theme = "nord";
        }
      }
    };

    zsh = {
      enable = true;
      shellAliases = {
        ".." = "cd .."; # cd to parent directory
        ls="exa -l --color=always --group-directories-first"; # ls with color and icons
        la="exa -al --color=always --group-directories-first"; # ls -al with color and icons
        sudo= "doas"; # adds a sudo replacement
        cat= "bat"; # makes bat the default for cat
        grep= "grep --color=auto"; # just adds color to grep
        upgrade= "sudo dnf upgrade && nix-env -u"; # upgrades your system
        wall= "./.autobg.sh"; # changes the wallpaper (X11 only)
        theme= "bash .tswitch.sh"; #changes the alacritty theme

        #git
        gm= "git merge $(git branch --show-current)"; #merges the current branch to main/master
        gc= "git commit -am "; #commits with a message
        gl= "git log --graph --oneline --decorate"; #shows a graph of commits

};

      initExtraFirst = ''
        export TERMINAL="alacritty"
        export BROWSER="firefox"
        export VISUAL="code"
        export EDITOR="micro"
        export "MICRO_TRUECOLOR=1"
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"

        # FZF bases
        export FZF_DEFAULT_OPTS="
          --color fg:#cdd6f4
          --color fg+:#cdd6f4
          --color bg:#1e1e2e
          --color bg+:#313244
          --color hl:#f38ba8
          --color hl+:#f38ba8
          --color info:#cba6f7
          --color prompt:#cba6f7
          --color spinner:#f5e0dc
          --color pointer:#f5e0dc
          --color marker:#f5e0dc
          --color border:#1e1e2e
          --color header:#f38ba8
          --prompt ' '
          --pointer ' λ'
      '';
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.6.4";
            sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
          };
        }
        {
          name = "fast-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zdharma";
            repo = "fast-syntax-highlighting";
            rev = "v1.55";
            sha256 = "0h7f27gz586xxw7cc0wyiv3bx0x3qih2wwh05ad85bh2h834ar8d";
          };
        }
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
      ];
    };
  };

  #pipewire
  security.rtkit.enable = true; # enable rtkit
  services.pipewire = {
    enable = true; # enable pipewire
    alsa.enable = true; # enable alsa
    alsa.support32Bit = true; # support 32 bit
    pulse.enable = true; # enable pulseaudio
  };


  # Environment variables
  home.sessionVariables = {
    EDITOR = "micro"; 
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };


  #packages to install
  home.packages = [
    #editors
    pkgs.vscodium
    pkgs.micro

    #browser
    pkgs.firefox

    #term stuff
    pkgs.tmux
    pkgs.alacritty

    #term tools
    pkgs.gcc
    pkgs.gnumake
    pkgs.cmake
    pkgs.python3
    pkgs.coreutils-full
    pkgs.zoxide
    pkgs.htop
    pkgs.opendoas
    pkgs.greetd
    pkgs.rust
    pkgs.cargo
    pkgs.unzip
    pkgs.wget
    pkgs.bat
    pkgs.sed 
    pkgs.neofetch 
    pkgs.curl 
    pkgs.tldr 
    pkgs.make 
    pkgs.tree 
    pkgs.exa 
    pkgs.acpi 
    pkgs.cmake 
    pkgs.ninja-build 
    pkgs.feh 
    pkgs.meson

    #visual stuff
    pkgs.conky
    pkgs.nitrogen
    pkgs.dunst
    pkgs.polkit_gnome
    pkgs.volumeicon
    pkgs.pixman
    pkgs.polybar

    #bluetooth network
    pkgs.networkmanager
    pkgs.bluez
    pkgs.bluez-tools
    pkgs.blueman

    #keymaps
    pkgs.sxhkd

    #python
    pkgs.python3 #python
    pkgs.pypy3 #pypy
    pkgs.python310Packages.pip #pip

    #video player
    pkgs.vlc

    #pipewire
    pkgs.pipewire #pipewire
    pkgs.wireplumber #wireplumber
    pkgs.pavucontrol #pavucontrol
    pkgs.easyeffects #easyeffects
    pkgs.helvum #helvum
  ];



  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch"; # enable sd-switch

  nix.checkConfig = true; # check config after switch
}


