{ config, lib, ... }:
let inherit (config.nvix) icons;
in {


  globals = {
    mapleader = config.nvix.leader; # sets <space> as my leader key
    floating_window_options.border = config.nvix.border;
  };

  opts = {

    clipboard = "unnamedplus";
    cursorline = true;
    cursorlineopt = "number";

    pumblend = 0;
    pumheight = 10;

    expandtab = true;
    shiftwidth = 2;
    smartindent = false; # smart indent doesnt let us indent comment lines easilly
    tabstop = 2;
    softtabstop = 2;

    ignorecase = true;
    smartcase = true;
    mouse = "a";
    cmdheight = 0;

    number = true;
    relativenumber = true;
    numberwidth = 2;
    ruler = false;

    signcolumn = "yes";
    splitbelow = true;
    splitright = true;
    splitkeep = "screen";
    termguicolors = true;

    conceallevel = 2;

    undofile = true;

    wrap = true;

    virtualedit = "block";
    winminwidth = 5;
    fileencoding = "utf-8";
    list = true;
    smoothscroll = true;
    autoread = true;
    fillchars = { eob = " "; };

    updatetime = 500;
  };

  autoCmd = [
    {
      desc = "Highlight on yank";
      event = [ "TextYankPost" ];
      callback = lib.nixvim.mkRaw #lua
        ''
          function()
            vim.highlight.on_yank()
          end
        '';
    }
  ];

  plugins = {
    direnv.enable = true;
  };


  extraLuaPackages = lp: with lp; [ luarocks ];
  extraConfigLua = with icons.diagnostics;
    # lua
    ''
      vim.opt.whichwrap:append("<>[]hl")
      -- uncomment line below to show spaces as a dot
      -- if i end up toggling this back on, perhaps look into including https://github.com/0xfraso/nvim-listchars
      -- vim.opt.listchars:append("space:·")

      -- below part set's the Diagnostic icons/colors
      local signs = {
        Hint = "${BoldHint}",
        Info = "${BoldInformation}",
        Warn = "${BoldWarning}",
        Error = "${BoldError}",
      }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    '';
  imports = with builtins; with lib;
    map (fn: ./${fn})
      (filter
        (fn: (
          fn != "default.nix"
          && !hasSuffix ".md" "${fn}"
        ))
        (attrNames (readDir ./.)));
}
