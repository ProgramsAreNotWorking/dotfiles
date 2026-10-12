return {
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = {
      "selimacerbas/live-server.nvim",
    },
    config = function()
      require("markdown_preview").setup({
        open_browser = true,
        default_theme = "dark",
        debounce_ms = 300,
      })
    end,
  },
}
