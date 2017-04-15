return function(items)
  local set = {}
  for _, item in ipairs(items) do
    set[item] = true
  end
  return set
end
