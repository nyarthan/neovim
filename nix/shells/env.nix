{
  pkgs,
}:
pkgs.mkShell {
  packages = [
    pkgs.stylua
    pkgs.mdformat
    pkgs.taplo
  ];
}
