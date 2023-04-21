---@meta

---@class colorbuddy.Color
---@field name string
---@field H number
---@field S number
---@field L number
---@field mods any
---@field children colorbuddy.Color[]
---@operator add(colorbuddy.Color): colorbuddy.Color
---@operator sub(colorbuddy.Color): colorbuddy.Color
local Color = {}

---@param H? number
---@param S? number
---@param L? number
---@return string
function Color:to_rgb(H, S, L) end

---@param name string
---@param ... string | table
---@return colorbuddy.Color
function Color:new_child(name, ...) end

local color = {}

---@class colorbuddy.ColorCtor
color.Color = {}

---@param name string
---@param H number
---@param S number
---@param L number
---@param mods any
---@return colorbuddy.Color
---@overload fun(name: string): colorbuddy.Color
---@overload fun(name: string, color: string): colorbuddy.Color
color.Color.new = function(name, H, S, L, mods) end

---@type table<string, colorbuddy.Color>
color.colors = {}

---@param c any
---@return boolean
color.is_color_object = function(c) end

return color
