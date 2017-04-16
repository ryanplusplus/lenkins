return function(args)
  local weblit = require 'weblit-app'
  weblit.use(require 'weblit-auto-headers')
  local web_hook_server = require './src/WebHookServer'(weblit)
  weblit.start()

  local build_manager = require './src/BuildManager'()
  local builder = require './src/SshBuilder'({
    server = 'ryan@192.168.1.15',
    port = 22,
    labels = { 'ubuntu', 'lenv' }
  })
  build_manager.add_builder(builder)

  local configamajig = require './src/Configamajig'(
    'sample/mach.lua-config.lua',
    'sample/webhook-test-config.lua'
  )

  local build_scheduler = require './src/BuildScheduler'(
    web_hook_server,
    build_manager,
    configamajig)

  -- for i = 1, 3 do
  --   print('scheduling ' .. i)
  --   build_manager.schedule_build({
  --     url = 'git@github.com:ryanplusplus/mach.lua.git',
  --     commit = 'master',
  --     labels = { 'ubuntu', 'lenv' },
  --     script = '.; busted',
  --     done = function()
  --       print('build ' .. i .. ' finished')
  --     end
  --   })
  -- end
end
