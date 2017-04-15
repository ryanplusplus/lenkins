local spawn = require 'coro-spawn'

return function(command, args)
  local result = spawn(command, { args = args })

  if type(result.pid) == 'string' then
    error('error executing ' .. command .. ': ' .. result.pid, 3)
  end

  local exit_code = result.waitExit()

  return exit_code, result.stdout.read()
end
