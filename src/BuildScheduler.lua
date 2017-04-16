--[[
inputs:
- build manager
- web hook server
- place where repo list is stored? some file?
]]

return function(web_hook_server, build_manager, configamajig)
  local function schedule(event, job, i)
    print('scheduling ' .. event.type .. ' build of ' .. event.url .. '[' .. i .. ']...')

    build_manager.schedule_build({
      url = event.url,
      commit = event.commit,
      labels = job.tools,
      script = job.script,
      timeout = job.timeout,
      done = function(exit_code, output)
        print(event.type .. ' build of ' .. event.url .. '[' .. i .. '] finished')
        print('exit_code', exit_code)
        print('output:')
        print(output)
      end
    })
  end

  web_hook_server.on_event(function(event)
    for _, config in ipairs(configamajig.get_configs()) do
      if event.owner == config.owner and event.repo == config.repo then
        for _, build in ipairs(config.builds) do
          if event.type == 'push' then
            if build.trigger.type == 'on_change' and build.trigger.branch == event.branch then
              for i, job in ipairs(build.jobs) do
                schedule(event, job, i)
              end
            end
          elseif event.type == 'pull_request' then
            if build.trigger.type == 'pull_request' then
              for i, job in ipairs(build.jobs) do
                schedule(event, job, i)
              end
            end
          end
        end
      end
    end
  end)
end
