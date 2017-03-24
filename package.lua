return {
  name = "ryanplusplus/lenkins",
  version = "0.0.1",
  description = "Lua-flavored CI",
  tags = { "ci", "luvit", "lua" },
  license = "MIT",
  author = { name = "Ryan Hartlage", email = "ryanplusplus@gmail.com" },
  homepage = "https://github.com/ryanplusplus/lenkins",
  dependencies = {
    'ryanplusplus/mach@1.0.11',
  },
  files = {
    "**.lua",
    "!test*"
  }
}
