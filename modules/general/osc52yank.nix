{ ... }:
{

# set yank,d,etc to use the osc52 clipboard by default
# which lets vim over ssh sessions send yanked content to
# your local systems clipboard
# see :help osc52 for more info
  extraConfigLua =
    # lua
    ''
      vim.o.clipboard = "unnamedplus"

      local function paste()
        return {
          vim.fn.split(vim.fn.getreg(""), "\n"),
          vim.fn.getregtype(""),
        }
      end

      vim.g.clipboard = {
        name = "OSC 52",
        copy = {
          ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
          ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
          ["+"] = paste,
          ["*"] = paste,
        },
      }
    '';

}
