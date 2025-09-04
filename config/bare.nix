{ self, ... }:
{
  imports = [
    self.nvixModules.utils
    self.nvixModules.general
    self.nvixModules.buffer
    self.nvixModules.explorer
    self.nvixModules.colorschemes
    self.nvixModules.snacks
  ];

  extraConfigLua =
  ''
  vim.o.background = "dark"
  '';

  colorscheme = "nightfox";
}
