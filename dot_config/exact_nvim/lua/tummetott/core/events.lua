-- Import lazys event handler
local Event = require('lazy.core.handler.event')

-- Setup the LazyFile event. This event is triggered whenever a file is opened,
-- created, or written to. It allows for lazy loading of plugins on. Copied from
-- LazyVim, credits: folke
local setup_lazy_file_event = function()
    local has_files = vim.fn.argc(-1) > 0
    local lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }

    if has_files then
        -- If Neovim starts with files in the arglist, events like 'BufReadPost'
        -- are triggered before 'VimEnter'. To prevent plugins loaded on
        -- 'LazyFile' from blocking the UI, we need to delay the execution of
        -- the event. We inform lazy about the existence of a user command
        -- 'LazyFile'.
        Event.mappings.LazyFile = {
            id = 'LazyFile',
            event = 'User',
            pattern = 'LazyFile',
        }
        Event.mappings['User LazyFile'] = Event.mappings.LazyFile
    else
        -- When nvim is started with an empty arglist, the events 'BufReadPost',
        -- 'BufNewFile', and 'BufWritePre' are not triggered during startup. We
        -- create a mapping in lazy, so plugins can use the new LazyFile event
        -- instead
        Event.mappings.LazyFile = {
            id = 'LazyFile',
            event = lazy_file_events,
        }
        Event.mappings['User LazyFile'] = Event.mappings.LazyFile
        return
    end

    -- Save events that are triggered before 'VimEnter' in a table
    local events = {} ---@type {event: string, buf: number, data?: any}[]

    local done = false
    local function load()
        if #events == 0 or done then
            return
        end
        done = true
        vim.api.nvim_del_augroup_by_name('lazy_file')

        ---@type table<string,string[]>
        local skips = {}
        -- Gather autogroups which exist before loading plugins
        for _, event in ipairs(events) do
            skips[event.event] = skips[event.event] or
            Event.get_augroups(event.event)
        end

        -- Trigger the LazyFile event and load plugins
        vim.api.nvim_exec_autocmds('User', {
            pattern = 'LazyFile',
            modeline = false,
        })
        for _, event in ipairs(events) do
            if vim.api.nvim_buf_is_valid(event.buf) then
                -- Trigger all events but exclude the autogroups that existed
                -- before loading plugins
                Event.trigger({
                    event = event.event,
                    exclude = skips[event.event],
                    data = event.data,
                    buf = event.buf,
                })
                -- Trigger FileType event if the buffer has a filetype. This
                -- fixes several issues with plugins that rely on the FileType
                if vim.bo[event.buf].filetype then
                    Event.trigger({
                        event = 'FileType',
                        buf = event.buf,
                    })
                end
            end
        end
        -- Not sure if this is needed
        vim.api.nvim_exec_autocmds(
            'CursorMoved',
            { modeline = false }
        )
        events = {}
    end

    -- schedule wrap so that nested autocmds are executed
    -- and the UI can continue rendering without blocking
    load = vim.schedule_wrap(load)

    vim.api.nvim_create_autocmd(lazy_file_events, {
        group = vim.api.nvim_create_augroup('lazy_file', { clear = true }),
        callback = function(event)
            table.insert(events, event)
            load()
        end,
    })
end


-- Setup the LazySearch event triggered when the user enters the search cmdline
-- for the first time
local setup_lazy_search_event = function()
    Event.mappings.LazySearch = {
        id = 'LazySearch',
        event = 'CmdlineEnter',
        pattern = { '/', '\\?' },
    }
    Event.mappings['User LazySearch'] = Event.mappings.LazyFile
end

setup_lazy_file_event()
setup_lazy_search_event()
