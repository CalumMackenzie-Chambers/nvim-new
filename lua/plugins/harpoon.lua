return {
  "ThePrimeagen/harpoon",
  version = false,
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>ha",
      function()
        require("harpoon"):list():append()
      end,
      desc = "Harpoon add file",
    },
    {
      "<leader>ht",
      function()
        require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
      end,
      desc = "Harpoon quick menu",
    },
    {
      "<leader>hn",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon quick menu",
    },
    {
      "<leader>he",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon quick menu",
    },
    {
      "<leader>ho",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon quick menu",
    },
    {
      "<leader>hi",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon quick menu",
    },
  },
}
