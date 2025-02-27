
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

-- Obtener la ruta donde está instalado el plugin
local plugin_path
local runtime_files = vim.api.nvim_get_runtime_file("lua/rust_nvim_plugin.lua", false)
if #runtime_files > 0 then
  plugin_path = vim.fn.fnamemodify(runtime_files[1], ":h")
else
  vim.notify("No se pudo encontrar la ruta del plugin", vim.log.levels.ERROR)
  return M
end

-- Construir la ruta a la biblioteca compartida
local extension = get_extension()
local lib_name = "librust_nvim_plugin"
if extension == "dll" then
  lib_name = "rust_nvim_plugin" -- Windows no usa el prefijo 'lib'
end
local lib_path = plugin_path .. "/" .. lib_name .. "." .. extension

-- Verificar que el archivo existe
if vim.fn.filereadable(lib_path) ~= 1 then
  vim.notify("El archivo de biblioteca no existe en: " .. lib_path, vim.log.levels.ERROR)
  return M
end


