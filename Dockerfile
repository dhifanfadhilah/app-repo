FROM maven:3.9.9-eclipse-temurin-21-jammy AS builder
WORKDIR /app
COPY pom.xml .

RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

FROM tomcat:10-jdk21
RUN useradd -m appuser
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=builder /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
RUN chown -R appuser:appuser /usr/local/tomcat
USER appuser
EXPOSE 8080
CMD ["catalina.sh", "run"]