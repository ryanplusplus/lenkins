return function(...)
  local configs = {}

  for _, file in ipairs({ ... }) do
    table.insert(configs, loadfile(file, 't')())
  end

  return {
    get_configs = function()
      return configs
    end
  }
end
