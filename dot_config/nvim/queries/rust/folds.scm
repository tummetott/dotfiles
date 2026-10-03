;; Override default treesitter folding.
;; Only create folds for item definitions and the leading import block.
;; Control flow, blocks, calls, and other expressions are intentionally not foldable.

[(mod_item)
 (function_item)
 (struct_item)
 (enum_item)
 (trait_item)
 (impl_item)
 (macro_definition)
 (use_declaration)+] @fold
