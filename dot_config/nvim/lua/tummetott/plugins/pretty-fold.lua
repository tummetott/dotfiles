return {
    'anuvyklack/pretty-fold.nvim',
    enabled = true,
    -- The fold text breaks when this plugin is lazily loaded, especially noticeable
    -- when using 'vim -d' to diff two random files.
    lazy = false,
    config = function()
        -- Check if nvim-scrollbar is active wihout lazy-loading it
        local has_scrollbar = function()
            return require 'tummetott.utils'.is_loaded('nvim-scrollbar') and
                require 'scrollbar.config'.get().show
        end

        -- Add a space to the right section if scrollbar is active
        local scrollbar_padding = function()
            return has_scrollbar() and ' ' or ''
        end

        -- Overwrite of the default provider because I want 'LINES' in caps
        local number_of_folded_lines = function()
            return string.format('%d LINES', vim.v.foldend - vim.v.foldstart + 1)
        end

        require('pretty-fold').setup {
            -- When using Treesitter as the foldmethod, only specific Treesitter
            -- nodes can be folded, such as functions and classes. Consequently,
            -- the foldtext should present the node's signature, typically found
            -- in the initial line of the folded content.
            global = {
                sections = {
                    left = { 'content' },
                    right = {
                        ' ',
                        number_of_folded_lines,
                        ' ',
                        scrollbar_padding,
                    },
                },
                fill_char = '⋅',
                remove_fold_markers = false,
                process_comment_signs = false,
                add_close_pattern = true,
                stop_word = {},
            },
            -- In a diff view, folds do not align with Treesitter nodes; they
            -- randomly collapse code that's identical on both sides. In this
            -- context, the foldtext should simply display the count of folded
            -- lines and no additional information.
            diff = {
                sections = {
                    right = {
                        ' ',
                        number_of_folded_lines,
                        ' ',
                        scrollbar_padding,
                    },
                },
                add_close_pattern = false,
            }
        }
    end,
}
