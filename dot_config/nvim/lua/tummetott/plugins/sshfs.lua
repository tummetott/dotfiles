return {
    'nosduco/remote-sshfs.nvim',
    enabled = true,
    init = function()
        require('which-key').add {
            {
                '<leader>r',
                group = 'Remote',
                icon = vim.g.nerdfonts and '' or nil,
            },
        }
    end,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'folke/snacks.nvim',
    },
    opts = {
        handlers = {
            on_disconnect = { clean_mount_folders = true },
        },
        ui = {
            picker = 'snacks',
            confirm = { connect = false },
        },
    },
    keys = {
        {
            '<leader>rr',
            function()
                require('remote-sshfs.api').connect({
                    layout = 'select',
                    -- Hide SSH config entries that are not mountable
                    transform = function(item)
                        return not vim.tbl_contains({
                            '*',
                            'github.com',
                            'github-private',
                            'ssh.gitlab.srlabs.de',
                        }, item.name)
                    end,
                })
            end,
            desc = 'Remote Connect',
        },
        {
            '<leader>rf',
            function() require('tummetott.utils.remote_picker').files() end,
            desc = 'Remote File',
        },
        {
            '<leader>rg',
            function() require('tummetott.utils.remote_picker').grep() end,
            desc = 'Remote Grep',
        },
        {
            '<leader>rd',
            function() require('remote-sshfs.api').disconnect() end,
            desc = 'Remote Disconnect',
        },
    },
}
