;; Override default treesitter folding.
;; Only create folds for top-level function definitions and declarations.
;; All other constructs (loops, conditionals, blocks, tables, etc.) are intentionally not foldable.

[(function_definition)
 (function_declaration)] @fold
