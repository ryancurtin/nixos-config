{ pkgs }:

with pkgs; [
  # General packages for development and system management
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  killall
  neofetch
  openssh
  openssl
  wget
  zip

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2

  # Cloud-related tools and SDKs
  docker
  docker-compose

  # Media-related packages
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs
  yarn

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jetbrains-mono
  jq
  ripgrep
  tree
  tmux
  unrar
  unzip
  zsh-powerlevel10k

  # Python packages
  python39
  python39Packages.virtualenv # globally install virtualenv

  # Elixir
  erlang_27
  elixir_1_17

  # Browser testing (Elixir w/ Wallaby)
  (chromedriver.overrideAttrs (oldAttrs: rec {
    version = "129.0.6668.58";
  }))

  # Terraform
  tenv

  # Vault
  vault

  # AWS
  awscli2

  # Rust
  rustup
  rustc

  # Databases
  sqlite
  postgresql_16
  unixODBC

  # Minio
  minio-client
]
