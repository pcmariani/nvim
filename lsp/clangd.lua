return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--fallback-style=llvm",
    -- Ensures macOS system headers are found even without a compile_commands.json
    "--extra-arg=-isysroot",
    "--extra-arg=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk",
  },
}
