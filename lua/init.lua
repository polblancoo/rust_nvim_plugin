-- Este archivo carga la biblioteca compilada de Rust
local M = {}

-- Determinar la extensión correcta según el sistema operativo
local function get_extension()
  local system = vim.loop.os_uname().sysname
  if system == "Windows" or system == "Windows_NT" then
    return "dll"
  elseif system == "Darwin" then
    return "dylib"
  else
    return "so"
  end
end

-- Construir la ruta a la biblioteca compartida
local extension = get_extension()
local plugin_path = vim.fn.fnamemodify(vim.api.nvim_get_runtime_file("lua/rust_nvim_plugin.lua", false)[1], ":h")
local lib_name = "librust_nvim_plugin"
if extension == "dll" then
  lib_name = "rust_nvim_plugin" -- Windows no usa el prefijo 'lib'
end
local lib_path = plugin_path .. "/" .. lib_name .. "." .. extension

-- Cargar la biblioteca
local ok, lib = pcall(vim.fn.load_dynamic_library, lib_path)
if not ok then
  vim.notify("No se pudo cargar la biblioteca Rust: " .. lib_path, vim.log.levels.ERROR)
  return M
end

-- Cargar el módulo
local rust_module
if lib.luaopen_rust_nvim_plugin then
  rust_module = lib.luaopen_rust_nvim_plugin()
  -- Copiar todas las funciones del módulo a M
  for k, v in pairs(rust_module) do
    M[k] = v
  end
else
  vim.notify("Error al inicializar el módulo Rust", vim.log.levels.ERROR)
end

return M
