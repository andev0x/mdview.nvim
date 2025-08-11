-- For more information on luacheckrc, see: https://github.com/mpeterv/luacheck
--
-- This file is automatically read by the luacheck linter.
--
-- Adding options:
--   --global <var>           Add a global variable.
--   --allow-defined <var>    Allow a global variable to be defined.
--   --allow-defined-top      Allow defining globals in the main chunk.
--   --no-global              Don't allow defining globals.
--   --new-globals <var>...   Define a new set of globals.
--   --not-globals <var>...   Remove globals from the set of globals.
--   --read-globals <var>...  Define a new set of read-only globals.
--   --ignore <code>...      Add a pattern for warnings to ignore.
--   --enable <warn>...       Enable a warning.
--   --disable <warn>...      Disable a warning.
--   --only <warn>...         Check for a specific warning.
--   --no-unused              Don't warn about unused variables.
--   --no-unused-args         Don't warn about unused arguments.
--   --no-unused-secondaries  Don't warn about unused variables set together with used ones.
--   --no-redefined           Don't warn about redefined variables.
--   --no-unused-globals      Don't warn about unused globals.
--   --no-max-line-length     Don't limit line length.
--   --no-max-code-line-length Don't limit code line length.
--   --no-max-string-line-length Don't limit string line length.
--   --no-max-comment-line-length Don't limit comment line length.
--   --no-cyclomatic-complexity Don't limit cyclomatic complexity.
--   --no-trailing-whitespace Don't warn about trailing whitespace.
--   --no-whitespace          Don't warn about inconsistent whitespace.
--   --no-unused-values       Don't warn about unused values.
--   --no-unreachable         Don't warn about unreachable code.
--   --no-shadowing           Don't warn about shadowing.
--   --no-self                Don't warn about self in methods.
--   --no-mixed-indent        Don't warn about mixed indentation.
--   --no-unused-labels       Don't warn about unused labels.
--   --no-deprecated          Don't warn about deprecated features.
--   --no-spell-check         Don't warn about spelling mistakes.
--
-- For more information on luacheckrc, see: https://github.com/mpeterv/luacheck

-- The following globals are provided by Neovim.
globals = {
  "vim",
  "describe",
  "it",
  "before_each",
  "after_each",
}
