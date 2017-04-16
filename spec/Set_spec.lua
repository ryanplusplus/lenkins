describe('Set', function()
  local Set = require 'Set'

  it('should create an empty set when given no elements', function()
    assert.are.same({}, Set())
    assert.are.same({}, Set({}))
  end)

  it('should create a set of the provided elements', function()
    assert.are.same({
      hello = true,
      goodbye = true,
      [3] = true
    }, Set({
      3,
      'hello',
      'goodbye'
    }))
  end)
end)
