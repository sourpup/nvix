{ config, lib, ... }:
let inherit (config.nvix) icons;
in {

  plugins.lualine.settings.sections.lualine_c = [
    {
      __unkeyed = "b:gitsigns_head";
      icon = "${icons.git.Branch}";
      color.gui = "bold";
    }
    {
      __unkeyed = "diff";
      source = lib.nixvim.mkRaw # lua 
        ''
          (function()
            local gitsigns = vim.b.gitsigns_status_dict
            if vim.b.gitsigns_status_dict then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end)
        '';
      symbols = {
        added = lib.nixvim.mkRaw ''"${icons.git.LineAdded}" .. " " '';
        modified = lib.nixvim.mkRaw ''"${icons.git.LineModified}".. " "'';
        removed = lib.nixvim.mkRaw ''"${icons.git.LineRemoved}".. " "'';
      };
    }

    {
      __unkeyed = "diagnostics";
      sources = { __unkeyed = "nvim_diagnostic"; };
      symbols = {
        error = lib.nixvim.mkRaw ''"${icons.diagnostics.BoldError}" .. " "'';
        warn = lib.nixvim.mkRaw ''"${icons.diagnostics.BoldWarning}" .. " "'';
        info = lib.nixvim.mkRaw ''"${icons.diagnostics.BoldInformation}" .. " "'';
        hint = lib.nixvim.mkRaw ''"${icons.diagnostics.BoldHint}" .. " "'';
      };
    }
  ];
}
