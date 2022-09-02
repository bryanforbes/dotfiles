-- try to require a module, return nil if not found
---@param moduleName string
---@return any
return function(moduleName)
  ---@type boolean
  local status
  ---@type any
  local mod
  status, mod = pcall(require, moduleName)

  if not status then
    return nil
  else
    return mod
  end
end
