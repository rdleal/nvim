return {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
        require('nightfox').setup({
            options = {
                transparent = true,     -- Disable setting background
            },
        })

       vim.cmd [[colorscheme nordfox]]
    end,
}
