---@class pr
local M = {}

---@class pr.Target
---@field branch string branch the PR merges into
---@field repo string web URL of the repository the PR targets

---@class pr.Item
---@field number integer
---@field title string
---@field author string
---@field text? string search text for the picker

---@class pr.Forge
---@field list string[] prints the open PRs as JSON
---@field item fun(data: table): pr.Item
---@field checkout fun(number: string): string[]
---@field view string[] prints the PR of the current branch as JSON
---@field target fun(data: table): pr.Target

---@type table<string, pr.Forge>
local forges = {
    github = {
        list = { 'gh', 'pr', 'list', '--limit', '100', '--json', 'number,title,author' },
        item = function(data)
            return { number = data.number, title = data.title, author = data.author.login }
        end,
        checkout = function(number) return { 'gh', 'pr', 'checkout', number } end,
        view = { 'gh', 'pr', 'view', '--json', 'baseRefName,url' },
        target = function(data)
            return {
                branch = data.baseRefName,
                repo = data.url:gsub('/pull/%d+$', '') --[[@as string]],
            }
        end,
    },
    gitlab = {
        list = { 'glab', 'mr', 'list', '--per-page', '100', '--output', 'json' },
        item = function(data)
            return { number = data.iid, title = data.title, author = data.author.username }
        end,
        checkout = function(number) return { 'glab', 'mr', 'checkout', number } end,
        view = { 'glab', 'mr', 'view', '--output', 'json' },
        target = function(data)
            return {
                branch = data.target_branch,
                repo = data.web_url:gsub('/%-/merge_requests/%d+$', '') --[[@as string]],
            }
        end,
    },
}

-- Raised after a failure is already reported, to unwind without a traceback
local abort = {}

---@param cmd string[]
---@param err string
---@return string
local function system(cmd, err)
    local ret = vim.system(cmd, { text = true }):wait()
    if ret.code ~= 0 then
        Snacks.notify.error({ err, ret.stderr }, { title = 'Pull Request' })
        error(abort)
    end
    return vim.trim(ret.stdout)
end

---@param fn fun()
local function run(fn)
    local ok, err = pcall(fn)
    if not ok and err ~= abort then
        error(err)
    end
end

-- Self-hosted GitLab instances use arbitrary hostnames, so every remote
-- outside github.com counts as GitLab.
---@return pr.Forge
local function get_forge()
    local url = system({ 'git', 'ls-remote', '--get-url' }, 'Failed to get the git remote')
    return url:find('github%.com') and forges.github or forges.gitlab
end

---@param repo string web URL of a repository
---@return string? name of the local remote pointing at the repository
local function find_remote(repo)
    local path = repo:match('^https?://[^/]+/(.+)$'):lower()
    local remotes = system({ 'git', 'remote', '-v' }, 'Failed to list git remotes')
    for name, url in remotes:gmatch('(%S+)%s+(%S+)%s+%(fetch%)') do
        local tail = url:lower():gsub('%.git$', ''):sub(-#path - 1)
        if tail == '/' .. path or tail == ':' .. path then
            return name
        end
    end
end

--- Pick an open PR and check out its branch. The forge CLI sets the branch
--- to track the contributor's fork, so pushes land in the PR.
function M.checkout()
    run(function()
        local forge = get_forge()
        local items = vim.tbl_map(function(data)
            local item = forge.item(data)
            item.text = ('#%d %s %s'):format(item.number, item.title, item.author)
            return item
        end, vim.json.decode(system(forge.list, 'Failed to list PRs')))
        if #items == 0 then
            Snacks.notify.info('No open PRs', { title = 'Pull Request' })
            return
        end

        Snacks.picker({
            title = 'Pull Requests',
            items = items,
            layout = { preset = 'ivy', preview = false },
            ---@param item pr.Item
            format = function(item)
                return {
                    { ('#%d '):format(item.number), 'SnacksPickerIdx' },
                    { item.title .. ' ' },
                    { item.author, 'SnacksPickerComment' },
                }
            end,
            ---@param item pr.Item
            confirm = function(picker, item)
                picker:close()
                run(function()
                    local number = tostring(item.number)
                    system(forge.checkout(number), 'Failed to check out PR #' .. number)
                    vim.cmd.checktime()
                end)
            end,
        })
    end)
end

--- Diff the current branch against the merge-base with its PR target branch.
--- The target branch is fetched first, so the merge-base is current and the
--- diff shows exactly the changes the PR introduces.
function M.diff()
    run(function()
        local forge = get_forge()
        local data = system(forge.view, 'No PR found for the current branch')
        local target = forge.target(vim.json.decode(data))

        -- A remote pointing at the target repository receives the branch in
        -- its remote-tracking ref (e.g. origin/main). Without one, the branch
        -- is fetched from the repository URL into a private ref.
        local remote = find_remote(target.repo)
        local ref = remote and ('refs/remotes/%s/%s'):format(remote, target.branch)
            or 'refs/pr/target'
        system(
            { 'git', 'fetch', remote or target.repo, ('+refs/heads/%s:%s'):format(target.branch, ref) },
            'Failed to fetch ' .. target.branch
        )

        vim.cmd(('DiffviewOpen %s...HEAD --imply-local'):format(ref))
    end)
end

return M
