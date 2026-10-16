local data_home = vim.env.XDG_DATA_HOME or vim.fs.joinpath(vim.env.HOME, '.local', 'share')
local nvim_source = vim.fs.joinpath(data_home, 'chezmoi', 'dot_config', 'nvim')

return {
    root_dir = function(bufnr, on_dir)
        -- If chezmoi source space
        local path = vim.api.nvim_buf_get_name(bufnr)
        if vim.fs.relpath(nvim_source, path) then
            on_dir(nvim_source)
            return
        end

        -- If chezmoi target space
        local nvim_config = vim.fn.stdpath('config')
        if vim.fs.relpath(nvim_config, path) then
            on_dir(nvim_config)
            return
        end

        -- If generic lua project
        on_dir(vim.fs.root(bufnr, vim.lsp.config.lua_ls.root_markers or { '.git' }))
    end,
}
