describe('BuildManager', function()
  local BuildManager = require 'BuildManager'
  local build_manager

  local mach = require 'deps/mach'

  local function Build(name, labels)
    return {
      done = mach.mock_function(name),
      labels = labels
    }
  end

  local function Builder(name, labels)
    local run_mock = mach.mock_function(name .. '.run')
    local _labels = {}
    local co

    for _, v in ipairs(labels) do
      _labels[v] = true
    end

    return {
      labels = _labels,
      run_mock = run_mock,

      run = function(build)
        run_mock(build)
        co = coroutine.running()
        coroutine.yield()
      end,

      complete = function()
        coroutine.resume(co)
      end
    }
  end

  local function nothing_should_happen()
    return mach.mock_function():may_be_called()
  end

  before_each(function()
    build_manager = BuildManager()
  end)

  it('should allow builds to be scheduled when there are no builders', function()
    local build1 = Build('build1', {})
    local build2 = Build('build2', {})

    nothing_should_happen():when(function()
      build_manager.schedule_build(build1)
      build_manager.schedule_build(build2)
    end)
  end)

  it('should run a build when scheduled and a builder is available', function()
    local build = Build('build', {})
    local builder = Builder('builder', {})

    build_manager.add_builder(builder)

    builder.run_mock:should_be_called_with(mach.match(build)):
      when(function()
        build_manager.schedule_build(build)
      end)
  end)

  it('should invoke build.done when the builder finishes running the build', function()
    local build = Build('build', {})
    local builder = Builder('builder', {})

    build_manager.add_builder(builder)

    mach.ignore_mocked_calls_when(function()
      build_manager.schedule_build(build)
    end)

    build.done:should_be_called():when(function()
      builder.complete()
    end)
  end)

  it('should run a build when scheduled and then a viable builder is added', function()
    local build = Build('build', {})
    local builder = Builder('builder', {})

    build_manager.schedule_build(build)

    builder.run_mock:should_be_called_with(mach.match(build)):
      when(function()
        build_manager.add_builder(builder)
      end)
  end)

  it('should run ready builds in FIFO order', function()
    local build1 = Build('build1', {})
    local build2 = Build('build2', {})
    local builder = Builder('builder', {})

    build_manager.schedule_build(build1)
    build_manager.schedule_build(build2)

    builder.run_mock:should_be_called_with(mach.match(build1)):
      when(function()
        build_manager.add_builder(builder)
      end)

    build1.done:should_be_called():
      and_then(builder.run_mock:should_be_called_with(mach.match(build2))):
      when(function()
        builder.complete()
      end)
  end)

  it('should run builds in parallel when multiple builders are available', function()
    local build1 = Build('build1', {})
    local build2 = Build('build2', {})
    local builder1 = Builder('builder1', {})
    local builder2 = Builder('builder2', {})

    build_manager.schedule_build(build1)
    build_manager.schedule_build(build2)

    builder1.run_mock:should_be_called_with(mach.match(build1)):
      and_then(builder2.run_mock:should_be_called_with(mach.match(build2))):
      when(function()
        build_manager.add_builder(builder1)
        build_manager.add_builder(builder2)
      end)
  end)

  it('should not run a build if no builders are available with all labels', function()
    local build1 = Build('build1', { 'a', 'b' })
    local build2 = Build('build2', { 'b', 'c' })
    local builder1 = Builder('builder1', { 'b' })
    local builder2 = Builder('builder2', { 'a', 'c' })

    build_manager.schedule_build(build1)
    build_manager.schedule_build(build2)

    nothing_should_happen():when(function()
      build_manager.add_builder(builder1)
      build_manager.add_builder(builder2)
    end)
  end)

  it('should match builds with builders that have matching labels', function()
    local build1 = Build('build1', { 'a', 'b' })
    local build2 = Build('build2', { 'b', 'c' })
    local builder1 = Builder('builder1', { 'b', 'c' })
    local builder2 = Builder('builder2', { 'a', 'b', 'd' })

    build_manager.schedule_build(build1)
    build_manager.schedule_build(build2)

    builder1.run_mock:should_be_called_with(mach.match(build2)):
      and_then(builder2.run_mock:should_be_called_with(mach.match(build1))):
      when(function()
        build_manager.add_builder(builder1)
        build_manager.add_builder(builder2)
      end)
  end)
end)
