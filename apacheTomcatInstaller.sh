#!/bin/bash

#1. Instalacion tomcat
# Actualizar el sistema
apt update -y
apt upgrade -y

# Instalar Java JDK
apt install openjdk-17-jdk
apt install openjdk-17-jre

# Crear usuario y grupo tomcat si no existen
if id "tomcat" >/dev/null 2>&1; then
        echo "Usuario tomcat ya existe"
else
        useradd -m -d /opt/tomcat -U -s /bin/false tomcat
fi

# Descargar Apache Tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz

# Crear directorio de instalación
mkdir -p /opt/tomcat

# Descomprimir Apache Tomcat en el directorio de instalación
tar xzvf apache-tomcat-10.1.18.tar.gz -C /opt/tomcat --strip-components=1

# Cambiar propietario y permisos del directorio de instalación
chown -R tomcat:tomcat /opt/tomcat
chmod -R u+x /opt/tomcat/bin


#2. Configuramos los usuarios administradores
echo "Configurando usuarios administrativos..."
# Buscar "</tomcat-users>" y añadir los usuarios administrativos. (el \ es para escapar el /)
# El comando sed -i hace los cambios directamente en el archivo y no muestra la salida por pantalla
sed -i 's/<\/tomcat-users>/  <role rolename="manager-gui" \/>\n  <user username="manager" password="manager_password" roles="manager-gui" \/>\n  <role rolename="admin-gui" \/>\n  <user username="admin" password="admin_password" roles="manager-gui,admin-gui" \/>\n<\/tomcat-users>/' /opt/tomcat/conf/tomcat-users.xml

echo "Configurando acceso a la página del Manager..."
sed -i '/<Valve/ s/^/<!-- /' /opt/tomcat/webapps/manager/META-INF/context.xml
sed -i '/:1|0:0:0:0:0:0:0:1" \/>/ s/$/ -->/' /opt/tomcat/webapps/manager/META-INF/context.xml

echo "Configurando acceso a la página del Host Manager..."
sed -i '/<Valve/ s/^/<!-- /' /opt/tomcat/webapps/host-manager/META-INF/context.xml
sed -i '/:1|0:0:0:0:0:0:0:1" \/>/ s/$/ -->/' /opt/tomcat/webapps/host-manager/META-INF/context.xml


# 3. Creamos el system service
# Crear el archivo tomcat.service y añadir el contenido
sudo bash -c 'cat > /etc/systemd/system/tomcat.service' <<-'EOF'
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

#4. Configuramos el JAVA_HOME
# Obtener la ruta de instalación de Java 1.17.0
JAVA_PATH=$(sudo update-java-alternatives -l | grep '1.17.0' | awk '{print $3}')

# Reemplazar JAVA_HOME en tomcat.service
sudo sed -i "s|JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64|JAVA_HOME=$JAVA_PATH|g" /etc/systemd/system/tomcat.service

# Recargar servicios systemd y habilitar Apache Tomcat
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

#5. Configuramos el firewall
# Abre el firewall
ufw allow 8080

echo "Instalación completada, acceder a http://server_domain_or_IP:8080"
