;; Override default treesitter folding.
;; Only create folds for functions and classes.
;; Control flow blocks and other constructs are intentionally not foldable.

[(function_definition)
 (class_definition)] @fold
