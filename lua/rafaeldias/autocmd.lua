local ftdetect_grp = vim.api.nvim_create_augroup("filetypedetect", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "[Jj]enkinsfile",
    group = ftdetect_grp,
    command = "set filetype=groovy",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = ".env.*",
    group = ftdetect_grp,
    command = "set filetype=sh"
})

