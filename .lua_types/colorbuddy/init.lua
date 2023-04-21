---@meta

local colorbuddy = {}

colorbuddy.colors = require('colorbuddy.color').colors
colorbuddy.Color = require('colorbuddy.color').Color
colorbuddy.groups = require('colorbuddy.group').groups
colorbuddy.Group = require('colorbuddy.group').Group
colorbuddy.styles = require('colorbuddy.style').styles

---@return colorbuddy.ColorCtor, table<string, colorbuddy.Color>, any, table<string, colorbuddy.Group>, table<string, colorbuddy.Style>
colorbuddy.setup = function() end

return colorbuddy
