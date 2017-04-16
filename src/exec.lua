local spawn = require 'coro-spawn'
local timer = require 'timer'

return function(command, args, timeout)
  local result = spawn(command, { args = args })

  if type(result.pid) == 'string' then
    error('error executing ' .. command .. ': ' .. result.pid, 3)
  end

  local killed
  local timer_id
  if timeout then
    timer_id = timer.setTimeout(timeout, function()
      result.handle:kill(9)
      killed = true
    end)
  end

  local exit_code = result.waitExit()

  if timer_id then
    timer.clearTimeout(timer_id)
  end

  return (not killed and exit_code or 1), result.stdout.read()
end
