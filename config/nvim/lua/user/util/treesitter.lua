local ts = require('nvim-treesitter')

local M = {}

M._parsers = nil
M._queries = {}

local function refresh()
  M._parsers = {}
  M._queries = {}

  for _, lang in ipairs(ts.get_installed('parsers')) do
    M._parsers[lang] = true
  end
end

---@param opts? TSConfig
function M.setup(opts)
  ts.setup(opts)
  refresh()
end

function M.has_parser(filetype)
  local lang = vim.treesitter.language.get_lang(filetype)
  return M._parsers[lang] or false
end

function M.has_query(filetype, query)
  local lang = vim.treesitter.language.get_lang(filetype)
  if not lang then
    return false
  end

  local key = lang .. ':' .. query
  if M._queries[key] == nil then
    M._queries[key] = vim.treesitter.query.get(lang, query) ~= nil
  end
  return M._queries[key]
end

function M.install_parser(filetype)
  local lang = vim.treesitter.language.get_lang(filetype)
  if lang and not M.has_parser(filetype) then
    ts.install({ lang }):wait(300000)
    refresh()
  end
end

return M
