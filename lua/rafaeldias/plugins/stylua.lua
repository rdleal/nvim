return {
    "ckipp01/stylua-nvim",
    config = function()
        require("stylua-nvim").setup()
        local format_sync_grp = vim.api.nvim_create_augroup("LuaFormat", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.lua",
            group = format_sync_grp,
            callback = function()
                require("stylua-nvim").format_file()
            end,
        })
    end
}
