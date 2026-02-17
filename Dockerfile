FROM tomcat:9.0

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file
COPY target/twoway-chat-app.war /usr/local/tomcat/webapps/ROOT.war

# Tell Tomcat to use Render's PORT
RUN sed -i 's/port="8080"/port="${PORT:-10000}"/' /usr/local/tomcat/conf/server.xml

EXPOSE 10000

CMD ["catalina.sh", "run"]
