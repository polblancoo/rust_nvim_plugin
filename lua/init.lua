-- ~/.config/nvim/lua/plugins/rust_nvim_plugin.lua
return {
  "tu-usuario-github/rust_nvim_plugin", -- Reemplaza con tu usuario y nombre de repo
  lazy = false, -- Cargar al inicio
  config = function()
    -- Cargar el plugin
    local ok, rust_plugin = pcall(require, "rust_nvim_plugin")
    if not ok then
      vim.notify("No se pudo cargar rust_nvim_plugin", vim.log.levels.ERROR)
      return
    end
    
    -- Registrar comandos
    vim.api.nvim_create_user_command("HolaMundo", function()
      print(rust_plugin.hola_mundo())
    end, {})
    
    vim.api.nvim_create_user_command("Suma", function(opts)
      local args = opts.fargs
      if #args == 2 then
        local a = tonumber(args[1])
        local b = tonumber(args[2])
        if a and b then
          print(string.format("%d + %d = %d", a, b, rust_plugin.suma(a, b)))
        else
          print("Los argumentos deben ser números")
        end
      else
        print("Uso: Suma <num1> <num2>")
      end
    end, {nargs = "*"})
    
    -- Mapeo de teclas
    vim.keymap.set("n", "<leader>hm", function()
      print(rust_plugin.hola_mundo())
    end, {desc = "Mostrar Hola Mundo"})
  end,
}
