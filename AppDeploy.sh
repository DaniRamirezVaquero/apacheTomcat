#!/bin/bash

# 6. Descargamos nuestro repositorio de GitHub
apt-intall git -y

mkdir /home/tmp
cd /home/tmp

git clone https://github.com/DaniRamirezVaquero/apacheTomcat.git

# 7. Compilamos el proyecto
cd /apacheTomcat/app
./gradlew war

# 8. Copiamos el war a la carpeta de tomcat
mv /app/build/libs/*.war /opt/tomcat/webapps/hola.war
