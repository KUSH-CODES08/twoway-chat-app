FROM tomcat:9.0-jdk17

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file
COPY twowaychatapp.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
