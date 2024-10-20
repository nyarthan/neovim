{
  pkgs,
}:
pkgs.mkShell {
  packages = [
    pkgs.stylua
    pkgs.mkformat
    pkgs.taplo
  ];
}
