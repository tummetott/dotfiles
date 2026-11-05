-- Snacks file and grep pickers that search a remote-sshfs mount on the remote
-- host. The stock snacks finders build the search command, which runs over
-- ssh in the remote directory backing the current working directory. Results
-- resolve through the local mount, so they open and preview like local files.
local M = {}

-- Per-source overrides. Files always uses rg, because the remote host needs
-- the same tool that snacks detects locally. Grep passes an explicit search
-- path, because rg without one searches stdin, which is a pipe under ssh.
local sources = {
    files = { title = 'Remote Files', cmd = 'rg' },
    grep = { title = 'Remote Grep', search_path = '.' },
}

--- Remote directory backing `cwd`, or nil when `cwd` lies outside the mount.
local function remote_dir(conn, cwd)
    local mount = conn.get_current_mount_point()
    if not vim.startswith(cwd .. '/', mount) then
        return
    end
    local relative = (cwd .. '/'):sub(#mount + 1)
    return (conn.get_current_host().Path or '.') .. '/' .. relative
end

--- Wraps a snacks finder so its process runs on `host` inside `dir`.
local function remote_finder(source, host, dir)
    return function(opts, ctx)
        local proc = require('snacks.picker.source.proc')
        local spawn = proc.proc
        -- ssh joins its arguments into one remote shell command
        proc.proc = function(proc_opts, proc_ctx)
            local command = { 'cd', vim.fn.shellescape(dir), '&&', proc_opts.cmd }
            for _, arg in ipairs(proc_opts.args or {}) do
                command[#command + 1] = vim.fn.shellescape(arg)
            end
            command[#command + 1] = opts.search_path
            proc_opts.cmd = 'ssh'
            proc_opts.args = { host, table.concat(command, ' ') }
            return spawn(proc_opts, proc_ctx)
        end
        local ok, finder = pcall(require('snacks.picker.source.' .. source)[source], opts, ctx)
        proc.proc = spawn
        if not ok then
            error(finder)
        end
        return finder
    end
end

local function pick(source)
    local conn = package.loaded['remote-sshfs.connections']
    local dir = conn and conn.is_connected() and remote_dir(conn, vim.fn.getcwd())
    if not dir then
        vim.notify('Working directory is not inside a remote mount', vim.log.levels.WARN)
        return
    end
    local host = conn.get_current_host().Name
    Snacks.picker.pick(source, vim.tbl_extend('force', sources[source], {
        finder = remote_finder(source, host, dir),
    }))
end

function M.files() pick('files') end

function M.grep() pick('grep') end

return M
