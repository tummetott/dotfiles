local conf = {
    cmd = (function()
        local path = {}
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
        path.data_dir = vim.fn.stdpath('cache') .. '/nvim-jdtls/' .. project_name

        local jdtls_install = vim.fn.expand('$MASON/packages/jdtls')

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
    root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),
    settings = {
        java = {}
    },
    flags = {
        allow_incremental_sync = true,
    },
    init_options = {
        bundles = {}
    },
}

require('jdtls').start_or_attach(conf)
