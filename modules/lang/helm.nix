{ lib, pkgs, ... }:
{
  plugins = {
    lsp.servers.helm_ls.enable = true;
  };
}
