return {
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                -- Only check the default target (defined in Cargo.toml) and skip benches, tests, etc.
                allTargets = false,
                -- Don’t run build.rs; faster but less precise code analysis
                buildScripts = {
                    enable = false,
                },
            },
            check = {
                -- Make rust-analyzer run `cargo check -p <current_package>`
                -- internally instead of `--workspace`; faster diagnostics, no
                -- cross-crate errors from other packages
                workspace = false,
            },
            procMacro = {
                -- Disable proc-macro expansion to improve responsiveness
                enable = false,
            },
            diagnostics = {
                -- Substrate macros can trigger false positives; disable noisy ones
                disabled = {
                    "unresolved-macro-call",
                    "macro-error",
                },
            },
            server = {
                -- Skip WASM build steps that slow down analysis
                extraEnv = { SKIP_WASM_BUILD = "1" },
            },
        },
    },
}
