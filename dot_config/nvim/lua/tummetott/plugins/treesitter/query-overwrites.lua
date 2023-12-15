local fold_overwrites = {
    lua = [[
        [(function_definition) (function_declaration)] @fold
    ]],
    c = [[
        [(function_definition) (struct_specifier)] @fold
    ]],
    python = [[
        [(function_definition) (class_definition)] @fold
    ]]
}

for lang, query in pairs(fold_overwrites) do
    pcall(vim.treesitter.query.set, lang, 'folds', query)
end
