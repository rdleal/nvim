return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "folke/trouble.nvim",
        "nvim-telescope/telescope.nvim"
    },
    opts = {
        langs = {
            "portuguese",
        }
    },
    config = function(_, options)
        local gpt = require("chatgpt")

        local user = vim.fn.expand("$USER")
        gpt.setup({
            api_key_cmd = "security find-generic-password -a " .. user .. " -s gpt-neovim -w secrets.keychain",
        })

        local gpt_flows_actions = require("chatgpt.flows.actions").read_actions()
        local gpt_actions = {}
        for key, _ in pairs(gpt_flows_actions) do
            table.insert(gpt_actions, key)
        end

        table.insert(options.langs, gpt_flows_actions["translate"].args["lang"].default)

        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        local lang_picker = function(opts, cb)
            opts = opts or {}
            cb = cb or function() end
            pickers.new(opts, {
                prompt_title = "Translate to",
                finder = finders.new_table({
                    results = options.langs,
                }),
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(prompt_bufnr, _)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local lang = action_state.get_selected_entry()
                        if not lang then
                            lang = { action_state.get_current_line() }
                        end
                        cb(lang[1])
                    end)
                    return true
                end,
            }):find()
        end

        local action_picker = function(opts)
            opts = opts or {}
            pickers.new(opts, {
                prompt_title = "ChatGPT Run Action",
                finder = finders.new_table({
                    results = gpt_actions
                }),
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(prompt_bufnr, _)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        if not selection then
                            vim.notify("You need to specify an action", vim.log.levels.WARN)
                        end
                        if selection[1] == "translate" then
                            lang_picker(opts, function(lang) gpt.run_action({ fargs = { selection[1], lang } }) end)
                            return nil
                        end
                        gpt.run_action({ fargs = { selection[1] } })
                    end)
                    return true
                end,
            }):find()
        end

        vim.keymap.set("n", "<leader>gpt", function() gpt.openChat() end)
        vim.keymap.set("n", "<leader>gpc", function() gpt.complete_code() end)
        vim.keymap.set({ "n", "v" }, "<leader>gpe", function() gpt.edit_with_instructions() end)
        vim.keymap.set({ "n", "v" }, "<leader>gpa",
            function() action_picker(require("telescope.themes").get_dropdown({})) end)
    end,
}
