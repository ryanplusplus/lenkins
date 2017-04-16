return {
  name = 'ryanplusplus/lenkins',
  version = '0.0.1',
  description = 'Lua-flavored CI',
  tags = { 'ci', 'luvit', 'lua' },
  license = 'MIT',
  author = { name = 'Ryan Hartlage', email = 'ryanplusplus@gmail.com' },
  homepage = 'https://github.com/ryanplusplus/lenkins',
  dependencies = {
    'ryanplusplus/mach@1.0.11',
    'ryanplusplus/proxyquire@1.0.2',
    'creationix/coro-spawn@3.0.0',
    'creationix/weblit@3.0.1',
    'luvit/luvit@2.12.1',
    'luvit/json@2.5.2'
  },
  files = {
    '**.lua',
    '!sample/**.lua',
    '!spec/**.lua'
  }
}
