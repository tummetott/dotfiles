local M = {}

--- Check if a plugin is defined in lazy.nvim without loading it.
---@param plugin string The plugin to search for
---@return boolean available Whether the plugin is available
function M.is_installed(plugin)
    local ok, lazy_config = pcall(require, 'lazy.core.config')
    return ok and lazy_config.plugins[plugin] ~= nil
end

--- Check if a plugin is loaded by lazy.nvim without loading it.
---@param plugin string The plugin to search for
---@return boolean loaded Whether the plugin is loaded
function M.is_loaded(plugin)
    local ok, lazy_config = pcall(require, 'lazy.core.config')
    return ok and lazy_config.plugins[plugin] ~= nil and
        lazy_config.plugins[plugin]._.loaded ~= nil
end

--- Closes LSP floating windows (diagnostics, signature help or hover windows).
---@param base_win_id window id of the underlying base window
---@return boolean closed Whether a window was closed
function M.close_lsp_float(base_win_id)
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for _, win_id in ipairs(wins) do
        if win_id ~= base_win_id then
            local win_cfg = vim.api.nvim_win_get_config(win_id)
            if win_cfg.relative == 'win' and win_cfg.win == base_win_id then
                vim.api.nvim_win_close(win_id, false)
                return true
            end
        end
    end
    return false
end

return M
