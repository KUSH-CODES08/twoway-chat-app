# ---------- BUILD STAGE ----------
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# ---------- RUN STAGE ----------
FROM tomcat:9.0

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from build stage
COPY --from=build /app/target/twoway-chat-app.war /usr/local/tomcat/webapps/ROOT.war

# Replace default server.xml to use Render PORT
RUN sed -i 's/port="8080"/port="${PORT}"/g' /usr/local/tomcat/conf/server.xml

EXPOSE 8080

CMD ["catalina.sh", "run"]
