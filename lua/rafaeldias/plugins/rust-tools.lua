return {
    'mrcjkb/rustaceanvim',
    version = '^3',
    ft = { 'rust' },
    opts = {
        tools = {
            hover_actions = {
                auto_focus = true,
            }
        },
    },
    config = function(_, opts)
        vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
}
