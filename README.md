# Bajando por las Américas #

¡Bienvenido a **Bajando por las Américas**! Un juego de plataformas y acción en 2.5D desarrollado en Lua utilizando el framework LÖVE.

---
>[!WARNING]
>### Nota Importante
>El guardado de partida del juego no esta terminado, se crea una sola partida funcional que se guarda en un solo archivo json, se puede >crear otra partida pero seguira abriendo ese mismo json.
>Para crear otra partida debes borrar el json en:
>Para Windows
>**OS(C:)/Usuarios/TuUsuario/AppData/Roaming/LOVE/bajando_por_las_americas**
>Para Linux
>**/mnt/c/Users/TuUsuario/AppData/Roaming/LOVE/bajando_por_las_americas**

ahi dentro encontraras un archivo llamado *save_slot1.json* ese es el que debes borrar
--- 
##  Requisitos Previos

Antes de empezar, asegúrate de tener clonado este repositorio en tu máquina local. Para ejecutar el juego, necesitarás instalar **LOVE (Love2D)**.

---

## Instrucciones de Instalación y Ejecución

Pasos para ejecutar el juego según tu sistema operativo:

---

### WINDOWS

## Instalación de LOVE2D:
1. Accede al sitio web oficial de LOVE2D y descarga el archivo `.ZIP` o el instalador según tu sistema operativo: [https://www.love2d.org/](https://www.love2d.org/)
2. **Si descargaste el `.ZIP`:** Extráelo y mueve la carpeta a la ruta que prefieras.  
   **Si descargaste el instalador:** Ejecútalo y sigue las instrucciones de instalación.
3. Copia la ruta del directorio donde se instaló LÖVE2D.
4. Presiona la combinación de teclas `Win + R`.
5. En la ventana Ejecutar, pega el siguiente comando y presiona Enter: `SystemPropertiesAdvanced`
6. Haz clic en **Variables de entorno**.
7. En *Variables del sistema*, selecciona `Path` y haz clic en **Editar**.
8. Haz clic en **Nuevo**, pega la ruta copiada y haz clic en **Aceptar**.

## Ejecucion del juego:
1. Asegúrate de estar en la carpeta raíz del repositorio.
2. Abre el `cmd`, accede al directorio del repositorio y ejecuta:
   ```bash
   love .


### LINUX
## Instalación de LOVE2D:
Accede al sitio web oficial de LÖVE2D: https://www.love2d.org/

Puedes optar por la opción llamada Ubuntu PPA (Personal Package Archive) o por AppImage x86_64:

**Opción 1: Ubuntu PPA**
Al hacer clic en Ubuntu PPA, la web te redirigirá a una página donde aparecerán los comandos para agregar el repositorio e instalar el framework:

Abre una terminal y ejecuta el primer comando para agregar el repositorio oficial:

Bash
sudo add-apt-repository ppa:bartbes/love-stable
Actualiza la lista de paquetes de tu sistema:

Bash
sudo apt update
Instala LÖVE2D ejecutando el siguiente comando (cuando te pida confirmación [s/n], confirma con "s" o "si"):

Bash
sudo apt-get install love
Al finalizar la instalación, puedes comprobar que se instaló correctamente verificando la versión:

Bash
love --version

## Ejecución del juego (PPA):

Abre la terminal.

Accede a la ruta raíz del repositorio y ejecuta:

Bash
love .


**Opción 2: AppImage x86_64**
Al hacer clic en AppImage x86_64 en la web de LÖVE2D, se descargará un archivo con extensión .AppImage. Tienes 2 opciones para ejecutar el juego desde la terminal:

## Alternativa A: 
Accede desde la terminal a la ruta donde se encuentra el archivo .AppImage que acabas de descargar y ejecuta el comando pasando la ruta del proyecto:

Bash
./nombreDelArchivo.AppImage '/ruta/del/directorio/raiz/del/repositorio'

## Alternativa B: 
1. Mueve el archivo .AppImage descargado directamente al directorio raíz del repositorio.
2. Accede desde la terminal a dicho directorio raíz.
3. Ejecuta el archivo pasando un punto como argumento:

Bash
./nombreDelArchivo.AppImage .



### MAC
## Instalación de LOVE2D:
Accede al sitio web oficial de LOVE2D y descarga el archivo .ZIP para macOS: https://www.love2d.org/

Descomprime el archivo .ZIP y arrastra la aplicación love.app a tu carpeta de Aplicaciones.

## Ejecución del juego:
Abre la terminal de macOS.

Accede al directorio raíz del repositorio.

Ejecuta el juego llamando al binario interno de la aplicación mediante el siguiente comando:

Bash
/Applications/love.app/Contents/MacOS/love .
(También puedes ejecutarlo de forma gráfica arrastrando la carpeta raíz del repositorio y soltándola directamente sobre el ícono de love.app)
