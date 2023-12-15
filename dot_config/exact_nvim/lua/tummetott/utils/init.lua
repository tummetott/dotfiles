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

M.which_key_queue = {}

--- Add a mapping to the which-key queue. The whole queue is registered as soon
--- which key is loaded
---@param mappings any A dict with which-key mapping
function M.which_key_register(mappings)
    for k,v in pairs(mappings) do
        M.which_key_queue[k] = v
    end
end

return M
