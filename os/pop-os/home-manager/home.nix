{
  config,
  pkgs,
  ...
}: {
  home.username = "nick";
  home.homeDirectory = "/home/nick";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    aspell
    bash
    bash-language-server
    bat
    cloc
    cowsay
    curl
    direnv
    eza
    fastfetch
    fd
    fnm
    fortune
    fzf
    gfold
    gh
    git
    git-cliff
    gnumake
    gnused
    graphviz
    helix
    htop
    hugo
    jq
    lolcat
    mold
    ripgrep
    scc
    shellcheck
    speedtest-cli
    tree
    wget
    yamllint
    yq
    zellij
    zoxide
    zsh
  ];
}
