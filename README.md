<h1 align="center">Bajando por las americas</h1>

Pasos para ejecutar el juego según tu sistema operativo:

<div style="display: flex; gap: 20px;">

  <div style="flex: 1; border-right: 2px solid #333; padding-right: 20px;">
    <strong>WINDOWS:</strong><br><br>
    <p><strong>Instalación de LOVE2D:</strong></p>
    <ol>
      <li>Accede al sitio web oficial de LOVE2D y descargar el archivo .ZIP o instalador según tu sistema operativo: <a href="https://www.love2d.org/">https://www.love2d.org/</a></li>
      <li>Si descargaste el .ZIP: extraerlo y mueve la carpeta a la ruta que prefieras.<br>
      Si descargaste el instalador: ejecutarlo y seguir las instrucciones de instalación.</li>
      <li>Copiar la ruta del directorio donde se instaló LOVE2D.</li>
      <li>Presionar la combinación de teclas <kbd>WINDOWS</kbd> + <kbd>R</kbd>.</li>
      <li>En la ventana ejecutar, pegar el siguiente comando: <code>SystemPropertiesAdvanced</code>.</li>
      <li>Click en "Variables de entorno".</li>
      <li>En "Variables de usuario", seleccionar <code>PATH</code> y click en "Editar".</li>
      <li>Click en "Nuevo" y pegar la ruta. Click en "Aceptar".</li>
    </ol>
    <p><strong>Ejecución del juego:</strong></p>
    <ol>
     <li>Abrir el <code>cmd</code> y acceder al directorio del repositorio, luego ejecutar: <code>love .</code></li>
    </ol>
  </div>
</div>

<hr style="border: 0; border-top: 1px solid #ccc; margin: 15px 0;">

<div style="display: flex; gap: 20px;">

  <div style="flex: 1; border-right: 2px solid #333; padding-right: 20px;">
    <strong>LINUX:</strong><br><br>
    <p><strong>Instalación de LOVE2D:</strong></p>
    <ol>
      <li>Accede al sitio web oficial de LOVE2D: <a href="https://www.love2d.org/">https://www.love2d.org/</a></li>
      <li>Puedes optar por la opción llamada Ubuntu PPA (personal package archive) o AppImage x86_64:</li><br>
      <ul>
        <li>
          <strong>Ubuntu PPA:</strong><br>
            <ul>
              <li>Al cliquear en Ubuntu PPA te redirigirá a una página en la cual te aparecerán dos comandos que deberas copiar:
                <ol>
                  <li><code>sudo add-apt-repository ppa:bartbes/love-stable</code></li>
                  <li><code>sudo apt update</code></li><br>
                </ol>
              </li>
              <li>Abre una terminal y pega el primer comando, presiona enter.</li><br>
              <li>Al terminar de ejecutarse lo anterior, pega el segundo comando, presiona enter.</li><br>
              <p><strong>Esto lo que hace es agregar un repositorio en el cual está LOVE2D.</strong></p><br>
              <li>Una vez agregado este repositorio, deberás instalar LOVE2D con el siguiente comando: <code>sudo apt-get install love</code> (Te pedirá una confirmación <code>[s/n]</code>, confirmas con "si").</li><br>
              <li>Al finalizar la instalación, para comprobar que se instaló correctamente puedes usar el comando: <code>love --version</code>, te debería aparecer la version de LOVE2D instalada.</li><br>
            </ul>
          <strong>Ejecución del juego:</strong><br>
          <ul>
            <li>Abre la terminal.</li>
            <li>Accede a la ruta raíz del repositorio y ejecuta el siguiente comando:</li>
            <code>love .</code>
          </ul>
        </li>
        <li>
          <strong>AppImage x86_64:</strong><br><br>
          <ol>
            <strong><p>Al hacer click en <code>AppImage x86_64</code> en la web de LOVE2D se descargará un archivo con extension <code>.AppImage</code>. Tienes 2 opciones para ejecutar el juego desde la terminal:</p></strong>
            <ol><strong><p>Opción 1:</p></strong>
              Accede desde la terminal a la ruta donde está el archivo <code>.AppImage</code> que acabas de descargar y ejecuta: <code>./nombreDelArchivo.AppImage 'ruta del directorio raiz del repositorio'</code><br><br>
              <strong><p>Opción 2:</p></strong>
                <ul>
                  <li>Mueve hacia el directorio raíz del repositorio el archivo <code>.AppImage</code> que descargaste</li>
                  <li>Accede desde la terminal hacia el directorio raíz del repositorio.</li>
                  <li>Ejecuta el siguiente comando: <code>./nombreDelArchivo.AppImage .</code></li>
                </ul>
            </ol>
          </ol>
        </li>
      </ul>
    </ol>
  </div>
</div>

<hr style="border: 0; border-top: 1px solid #ccc; margin: 15px 0;">

  <div style="flex: 1; border-right: 2px solid #333; padding-right: 20px;">
    <strong>MAC:</strong><br><br>
    <p><strong>Instalación de LOVE2D:</strong></p>
    <ol>
      <li>Accede al sitio web oficial de LOVE2D y descargar el archivo .ZIP: <a href="https://www.love2d.org/">https://www.love2d.org/</a>
    </ol>
    <p><strong>Ejecución del juego:</strong></p>
    <ol>
     <!-- <li>Abrir el <code>cmd</code> y acceder al directorio del repositorio, luego ejecutar: <code>love .</code></li> -->
    </ol>
  </div>
</div>
