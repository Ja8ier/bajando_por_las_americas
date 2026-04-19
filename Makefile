CPP_DIR = src/cpp
INC_DIR = $(CPP_DIR)/include
LIB_DIR = $(CPP_DIR)/lib
OUT_DIR = $(CPP_DIR)/bin

ifeq ($(OS),Windows_NT)
    NAME = $(OUT_DIR)/engine.dll
    LUA_BIND = $(LIB_DIR)/lua51.dll
    MKDIR = if not exist $(subst /,\,$(OUT_DIR)) mkdir $(subst /,\,$(OUT_DIR))
    RM = del /q /f
    LOVE = love
else
    NAME = $(OUT_DIR)/engine.so
    LUA_BIND = -llua51
    MKDIR = mkdir -p $(OUT_DIR)
    RM = rm -rf
    LOVE = love
endif

all: $(NAME)

$(NAME):
	$(MKDIR)
	g++ -shared -fPIC -o $(NAME) $(CPP_DIR)/engine.cpp -I$(INC_DIR) $(LUA_BIND) -s

run: all
	$(LOVE) .

clean:
	$(RM) $(OUT_DIR)

# ==============================================================================
# INSTRUCTIVO PARA EQUIPO (WINDOWS / LINUX)
# ==============================================================================
# 
# WINDOWS:
# 1. Asegúrate de tener MinGW (g++) y Make en tu PATH.
# 2. Solo ejecuta 'make run' y el sistema usará la DLL en src/cpp/lib.
#
# LINUX:
# 1. Instala las dependencias de desarrollo de Lua 5.1 y LÖVE:
#    En Ubuntu/Debian: sudo apt install liblua5.1-0-dev love build-essential
#    En Fedora: sudo dnf install lua-devel love
#    En Arch: sudo pacman -S lua51 love
# 2. Ejecuta 'make run'. El Makefile detectará tu OS y usará las librerías del sistema.
#
# NOTA: No suban archivos .dll, .so o carpetas 'bin' al repositorio. 
# El .gitignore ya debería estar filtrándolos.
# ==============================================================================