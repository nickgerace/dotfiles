{pkgs, ...}: {
  imports = [
    ./common.nix
  ];

  environment.systemPackages = with pkgs; [
    graphviz
    nodejs
    vscode-langservers-extracted
  ];
}
