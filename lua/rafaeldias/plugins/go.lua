return {
    'ray-x/go.nvim',
    dependencies = { 'ray-x/guihua.lua' },
    config = function()
        require('go').setup()

        local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            group = format_sync_grp,
            callback = function()
                require("go.format").goimport()
                --vim.lsp.buf.format({async = false, timeout_ms = 10000})
            end,
        })
    end,
}
