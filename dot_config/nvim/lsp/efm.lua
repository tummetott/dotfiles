-- shellcheck must be in PATH. Install with Mason
return {
    settings = {
        rootMarkers = { '.git/' },
        languages = {
            sh = {
                -- Each formatter gets one table
                {
                    lintCommand = 'shellcheck -e SC2164 -f gcc -x',
                    lintSource = 'shellcheck',
                    lintFormats = {
                        '%f:%l:%c: %trror: %m',
                        '%f:%l:%c: %tarning: %m',
                        '%f:%l:%c: %tote: %m',
                    },
                },
                -- Next formatter here..
            },
        }
    },
    init_options = { documentFormatting = true },
    filetypes = { 'bash', 'sh' },
}
