---@meta

---@class colorbuddy.Group
---@field name string
---@field fg colorbuddy.Color
---@field style colorbuddy.Style
---@field guisp colorbuddy.Color
---@field blend number
---@field children { fg: table<string, boolean>, bg: table<string, boolean>, style: table<string, boolean>, guisp: table<string, boolean> }
local Group = {}

local group

---@class colorbuddy.GroupCtor
group.Group = {}

---@param name string
---@param fg? colorbuddy.Color|colorbuddy.Group|nil
---@param bg? colorbuddy.Color|colorbuddy.Group|nil
---@param style? colorbuddy.Style|nil
---@param guisp? colorbuddy.Color|colorbuddy.Group|nil
---@param blend? number
---@param bang? boolean
---@return colorbuddy.Group
group.Group.default = function(name, fg, bg, style, guisp, blend, bang) end

---@param name string
---@param fg? colorbuddy.Color|colorbuddy.Group|nil
---@param bg? colorbuddy.Color|colorbuddy.Group|nil
---@param style? colorbuddy.Style|nil
---@param guisp? colorbuddy.Color|colorbuddy.Group|nil
---@param blend? number
---@param bang? boolean
---@return colorbuddy.Group
group.Group.new = function(name, fg, bg, style, guisp, blend, bang) end

---@param name string
---@param linked_group colorbuddy.Group
---@return colorbuddy.Group
group.Group.link = function(name, linked_group) end

---@type table<string, colorbuddy.Group>
group.groups = {}

---@param g any
---@return boolean
group.is_group_object = function(g) end

return group
