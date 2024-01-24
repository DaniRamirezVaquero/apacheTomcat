# Instalación de Apache Tomcat

Este script de Bash automatiza la instalación de Apache Tomcat en un sistema Linux. El script realiza las siguientes tareas:

1. Actualiza el sistema.
2. Instala Java JDK y JRE.
3. Crea un usuario y grupo 'tomcat' si no existen.
4. Descarga Apache Tomcat y lo descomprime en el directorio de instalación.
5. Configura usuarios administradores en el archivo `tomcat-users.xml`.
6. Elimina restricciones por defecto en los archivos de configuración de Tomcat.
7. Crea un servicio systemd para gestionar Apache Tomcat.
8. Abre el puerto 8080 en el firewall.
9. Muestra un mensaje indicando que la instalación se ha completado.

## Uso

1. Descarga el script:
   ```bash
   https://github.com/DaniRamirezVaquero/apacheTomcat.git

2. Otorga permisos de ejecución al script:
   ```bash
   chmod +x apacheTomcatInstaller.sh

3. Ejecuta el script
   ```bash
   sudo ./apacheTomcatInstaller.sh

## Notas
- Se recomienda revisar y personalizar las contraseñas y configuraciones según tus necesidades antes de ejecutar el script.
- Asegúrate de que el usuario que ejecuta el script tenga los permisos necesarios para realizar las operaciones.
- Este script ha sido probado en Ubuntu 20.04.
