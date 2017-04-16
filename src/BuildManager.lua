local BuilderPinger = require './BuilderPinger'

local function builder_can_build(builder, build)
  if builder.busy then return false end
  for _, label in ipairs(build.labels) do
    if not builder.labels[label] then
      return false
    end
  end
  return true
end

return function()
  local pending_builds = {}
  local builders = {}

  local execute_build

  local function try_to_start_pending_builds()
    for build_index, build in ipairs(pending_builds) do
      for _, builder in ipairs(builders) do
        if builder_can_build(builder, build) and builder.alive then
          table.remove(pending_builds, build_index)
          execute_build(builder, build)
        end
      end
    end
  end

  execute_build = function(builder, build)
    coroutine.wrap(function()
      builder.busy = true
      -- fixme test that this is called with args
      build.done(builder.run(build))
      builder.busy = false
      try_to_start_pending_builds()
    end)()
  end

  BuilderPinger(builders, 60 * 1000, try_to_start_pending_builds)

  return {
    schedule_build = function(build)
      table.insert(pending_builds, build)
      try_to_start_pending_builds()
    end,

    add_builder = function(builder)
      table.insert(builders, builder)
      try_to_start_pending_builds()
    end

  -- fixme: support remove_builder
  }
end
