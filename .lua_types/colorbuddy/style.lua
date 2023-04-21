---@meta

---@class colorbuddy.Style
---@field name string
---@field values table<string, boolean>
---@operator add(colorbuddy.Style): colorbuddy.Style
---@operator sub(colorbuddy.Style): colorbuddy.Style
local Style = {}

---@return string
function Style:to_nvim() end

local style = {}

---@class colorbuddy.style.styles
---@field bold colorbuddy.Style
---@field underline colorbuddy.Style
---@field undercurl colorbuddy.Style
---@field strikethrough colorbuddy.Style
---@field reverse colorbuddy.Style
---@field inverse colorbuddy.Style
---@field italic colorbuddy.Style
---@field standout colorbuddy.Style
---@field nocombine colorbuddy.Style
---@field NONE colorbuddy.Style
---@field none colorbuddy.Style
style.styles = {}

---@param s any
---@return boolean
style.is_style_object = function(s) end

return style
