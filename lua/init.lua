-- lua/rust_nvim_plugin.lua
local ffi = require("ffi")
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

-- Cargar la biblioteca usando ffi
local ok, lib = pcall(ffi.load, lib_path)
if not ok then
  vim.notify("No se pudo cargar la biblioteca: " .. tostring(lib), vim.log.levels.ERROR)
  return M
end

-- Definir las funciones de Rust usando ffi.cdef
ffi.cdef[[
  const char* hola_mundo();
  int suma(int a, int b);
]]

-- Inicializar el módulo
M.hola_mundo = function()
  return ffi.string(lib.hola_mundo())
end

M.suma = function(a, b)
  return lib.suma(a, b)
end

return M
