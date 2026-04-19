extern "C" {
    #include <lua.h>
    #include <lualib.h>
    #include <lauxlib.h>
}

#ifdef _WIN32
    #define EXPORT extern "C" __declspec(dllexport)
#else
    #define EXPORT extern "C" __attribute__((visibility("default")))
#endif

// --- Definicion de las funcionalidades ---

int multiplicar(lua_State* L) {

    double n = luaL_checknumber(L, 1); 
    
    lua_pushnumber(L, n * 2);
    return 1;
}

// Aquí irán tus futuras funciones de Árboles, Heaps, etc.
// int insertarEnArbol(lua_State* L) { ... }

static const struct luaL_Reg functionalities [] = {
    {"multiplicar", multiplicar},
    // {"insertar", insertarEnArbol},
    {NULL, NULL}
};

// --- INICIALIZACIÓN ---

EXPORT int luaopen_engine(lua_State* L) {
    luaL_register(L, "engine", functionalities);
    return 1;
}