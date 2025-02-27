// src/lib.rs
use mlua::prelude::*;

#[mlua::lua_module]
fn rust_nvim_plugin(lua: &Lua) -> LuaResult<LuaTable> {
    // Crear una tabla para contener las funciones del módulo
    let exports = lua.create_table()?;
    
    // Agregar la función "hola_mundo"
    exports.set(
        "hola_mundo",
        lua.create_function(|_, ()| Ok("¡Hola mundo desde Rust!".to_string()))?,
    )?;
    
    // Agregar la función "suma"
    exports.set(
        "suma",
        lua.create_function(|_, (a, b): (i64, i64)| Ok(a + b))?,
    )?;
    
    Ok(exports)
}
