local exec = require './exec'
local Set = require './Set'

return function(config)
  return {
    labels = Set(config.labels),

    alive = function()
      return 0 == exec('ssh', { config.server, '-p' .. tostring(config.port or 22), 'exit' })
    end,

    run = function(build_info)
      local command = 'BASH_XTRACEFD=1; set -x; ' .. table.concat({
        'rm -rf repo',
        'git clone --recursive ' .. build_info.url .. ' repo',
        'cd repo',
        'git checkout ' .. build_info.commit,
        'sh ' .. build_info.script
      }, ' 2>&1 && ') .. ' 2>&1'

      local exit_code, output = exec('ssh', {
        config.server,
        '-p' .. (config.port or 22),
        '-o StrictHostKeyChecking=no',
        command
      })
      print(exit_code)
      print(output)
    end
  }
end
