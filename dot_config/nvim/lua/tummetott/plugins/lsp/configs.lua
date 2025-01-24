local M = {}

local lsp_group = vim.api.nvim_create_augroup('lsp_group', { clear = true })

local LspConfig = {}
LspConfig.__index = LspConfig

-- Constructor for a new LSP configuration
function LspConfig:new(base_config)
    local instance = base_config or {}
    setmetatable(instance, self)
    return instance
end

-- Method to merge configurations
function LspConfig:extend(override_config)
    return LspConfig:new(vim.tbl_deep_extend("force", self, override_config))
end

M.base = LspConfig:new({
    on_attach = function(client, bufnr)
        -- Setup my LSP keymaps
        require('tummetott.plugins.lsp.keymaps').register(client, bufnr)
        -- Show signature help automatically
        require('tummetott.plugins.lsp.signature').setup(client, bufnr)
        -- Autocmd to reset document highlights as soon as the cursor holds
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            callback = vim.lsp.buf.clear_references,
            group = lsp_group,
            buffer = bufnr,
        })
    end,
    capabilities = (function()
        local loaded, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
        if loaded then
            return cmp_nvim_lsp.default_capabilities()
        end
    end)(),
})

---
-- Specific LSP configurations
---

M.efm = M.base:extend({
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
})

M.java_language_server = M.base:extend({
    -- This LSP is not globally installed, so we need to specify the command to run
    cmd = (function()
        -- Get the path to the installed jdtls
        local jdtls_install = require('mason-registry')
            .get_package('java-language-server')
            :get_install_path()
        -- Get the OS specific script to start the server
        local os = vim.fn.has('mac') == 1 and 'mac'
            or vim.fn.has('unix') == 1 and 'linux'
            or vim.fn.has('win32') == 1 and 'win'
        -- Return the command to start the server
        return { vim.fn.expand(jdtls_install .. '/dist/lang_server_' .. os .. '.sh') }
    end)(),
})

M.jdtls = M.base:extend({
    cmd = (function()
        local path = {}
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
        path.data_dir = vim.fn.stdpath('cache') .. '/nvim-jdtls/' .. project_name

        local jdtls_install = require('mason-registry')
            .get_package('jdtls')
            :get_install_path()

        path.java_agent = jdtls_install .. '/lombok.jar'
        path.launcher_jar = vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar')

        if vim.fn.has('mac') == 1 then
            path.platform_config = jdtls_install .. '/config_mac'
        elseif vim.fn.has('unix') == 1 then
            path.platform_config = jdtls_install .. '/config_linux'
        elseif vim.fn.has('win32') == 1 then
            path.platform_config = jdtls_install .. '/config_win'
        end

        return {
            'java',
            '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            '-Dosgi.bundles.defaultStartLevel=4',
            '-Declipse.product=org.eclipse.jdt.ls.core.product',
            '-Dlog.protocol=true',
            '-Dlog.level=ALL',
            '-javaagent:' .. path.java_agent,
            '-Xmx1g',
            '--add-modules=ALL-SYSTEM',
            '--add-opens', 'java.base/java.util=ALL-UNNAMED',
            '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
            '-jar', path.launcher_jar,
            '-configuration', path.platform_config,
            '-data', path.data_dir,
        }
    end)(),
    settings = (function()
        local jdtls = require('jdtls')
        local runtimes = {
            -- Note: the field `name` must be a valid `ExecutionEnvironment`,
            -- you can find the list here: 
            -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
            --
            -- This example assume you are using sdkman: https://sdkman.io
            -- {
            --   name = 'JavaSE-17',
            --   path = vim.fn.expand('~/.sdkman/candidates/java/17.0.6-tem'),
            -- },
            -- {
            --   name = 'JavaSE-18',
            --   path = vim.fn.expand('~/.sdkman/candidates/java/18.0.2-amzn'),
            -- },
        }
        return {
            java = {
                -- jdt = {
                --   ls = {
                --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
                --   }
                -- },
                eclipse = {
                    downloadSources = true,
                },
                configuration = {
                    updateBuildConfiguration = 'interactive',
                    runtimes = runtimes,
                },
                maven = {
                    downloadSources = true,
                },
                implementationsCodeLens = {
                    enabled = true,
                },
                referencesCodeLens = {
                    enabled = true,
                },
                -- inlayHints = {
                --   parameterNames = {
                --     enabled = 'all' -- literals, all, none
                --   }
                -- },
                format = {
                    enabled = true,
                    -- settings = {
                    --   profile = 'asdf'
                    -- },
                }
            },
            signatureHelp = {
                enabled = true,
            },
            completion = {
                favoriteStaticMembers = {
                    'org.hamcrest.MatcherAssert.assertThat',
                    'org.hamcrest.Matchers.*',
                    'org.hamcrest.CoreMatchers.*',
                    'org.junit.jupiter.api.Assertions.*',
                    'java.util.Objects.requireNonNull',
                    'java.util.Objects.requireNonNullElse',
                    'org.mockito.Mockito.*',
                },
            },
            contentProvider = {
                preferred = 'fernflower',
            },
            extendedClientCapabilities = jdtls.extendedClientCapabilities,
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                }
            },
            codeGeneration = {
                toString = {
                    template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
                },
                useBlocks = true,
            },
        }
    end)(),
    on_attach = function(client, bufnr)
        -- Enable codelens
        pcall(vim.lsp.codelens.refresh)
        vim.api.nvim_create_autocmd('BufWritePost', {
            buffer = bufnr,
            group = lsp_group,
            desc = 'refresh codelens',
            callback = function()
                pcall(vim.lsp.codelens.refresh)
            end,
        })
        -- Enable debugger
        require('jdtls').setup_dap({ hotcodereplace = 'auto' })
        require('jdtls.dap').setup_dap_main_class_configs()

        -- -- Setup keymaps
        -- local opts = { buffer = bufnr }
        -- vim.keymap.set('n', '<A-o>', "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
        -- vim.keymap.set('n', 'crv', "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
        -- vim.keymap.set('x', 'crv', "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
        -- vim.keymap.set('n', 'crc', "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
        -- vim.keymap.set('x', 'crc', "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
        -- vim.keymap.set('x', 'crm', "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)
        -- vim.keymap.set('n', '<leader>df', "<cmd>lua require('jdtls').test_class()<cr>", opts)
        -- vim.keymap.set('n', '<leader>dn', "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)

        -- Call the base on_attach function
        M.base.on_attach(client, bufnr)
    end,
    capabilities = (function()
        local jdtls = require('jdtls')
        jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        local loaded, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
        return vim.tbl_deep_extend(
            'force',
            vim.lsp.protocol.make_client_capabilities(),
            loaded and cmp_nvim_lsp.default_capabilities() or {}
        )
    end)(),
    root_dir = require('jdtls').setup.find_root({ '.git', 'gradlew', 'mvnw' }),
    flags = {
        allow_incremental_sync = true,
    },
    init_options = {
        bundles = (function()
            local bundles = {}

            -- Include java-test bundle if present
            local java_test_path = require('mason-registry')
                .get_package('java-test')
                :get_install_path()

            local java_test_bundle = vim.split(
                vim.fn.glob(java_test_path .. '/extension/server/*.jar'),
                '\n'
            )

            if java_test_bundle[1] ~= '' then
                vim.list_extend(bundles, java_test_bundle)
            end

            -- Include java-debug-adapter bundle if present
            local java_debug_path = require('mason-registry')
                .get_package('java-debug-adapter')
                :get_install_path()

            local java_debug_bundle = vim.split(
                vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'),
                '\n'
            )

            if java_debug_bundle[1] ~= '' then
                vim.list_extend(bundles, java_debug_bundle)
            end
            return bundles
        end)(),
    },
})

return M
