local function req_one(moduleName)
  local status, mod = pcall(require, moduleName)

  if not status then
    return nil
  end

  return mod
end

local function req_multiple(moduleNames)
  local modules = {}
  local has_nil = false

  for index, moduleName in ipairs(moduleNames) do
    local mod = req_one(moduleName)

    has_nil = has_nil or mod == nil

    modules[index] = mod
  end

  return has_nil, modules
end

-- try to require a module, return nil if not found
local function req(moduleName, func)
  if type(moduleName) == 'string' then
    local mod = req_one(moduleName)

    if mod ~= nil and type(func) == 'function' then
      return func(mod)
    end

    return mod
  else
    local has_nil, modules = req_multiple(moduleName)

    if not has_nil and type(func) == 'function' then
      return func(unpack(modules))
    end

    return unpack(modules)
  end
end

return req
