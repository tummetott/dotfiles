;; Override default treesitter folding.
;; Only create folds for function definitions.
;; Declarations and other constructs are intentionally not foldable.

(function_definition) @fold
