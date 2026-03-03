{
self ? (import ./. { }),
system ? (builtins.currentSystem or null),
sources ? (import ./lon.nix),

nixpkgs ? sources.nixpkgs,
pkgs ? (import nixpkgs { inherit system; }),
lib ? pkgs.lib,

}:
let
  nixvim = import sources.nixvim;
  self.nvixModules = {
    utils = ./modules/utils; # Contains utility functions

    git = ./modules/git;
    lsp = ./modules/lsp;
    cmp = ./modules/cmp;
    tex = ./modules/tex;
    lang = ./modules/lang;
    snacks = ./modules/snacks;
    buffer = ./modules/buffer; # Buffer manager/bufferline
    general = ./modules/general; # General Neovim config
    lualine = ./modules/lualine;
    explorer = ./modules/explorer;
    firenvim = ./modules/firenvim;
    dashboard = ./modules/dashboard;
    aesthetics = ./modules/aesthetics;
    treesitter = ./modules/treesitter;
    auto-session = ./modules/auto-session;
    colorschemes = ./modules/colorschemes;
  };
  extraSpecialArgs = {
      inherit sources self; # This will ensure all sources are available in the module
  };
  nvix = {
      inherit pkgs extraSpecialArgs;
      module = import ./config/core.nix;
  };

in
{
  packages = nixvim.legacyPackages.${system}.makeNixvimWithModule nvix ;
}
