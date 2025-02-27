-- init.lua
local M = {}

-- Intenta cargar el módulo Rust
local ok, rust_module = pcall(require, "rust_nvim_plugin")
if not ok then
  vim.notify("Error al cargar el módulo Rust: " .. tostring(rust_module), vim.log.levels.ERROR)
  return M
end

-- Exporta las funciones desde el módulo Rust
M.hola_mundo = rust_module.hola_mundo
M.suma = rust_module.suma

return M
