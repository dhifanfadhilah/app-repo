FROM maven:3.9.9-eclipse-temurin-21-jammy AS builder
COPY ./ gitops-project
RUN cd gitops-project && mvn install -DskipTests

FROM tomcat:10-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=builder gitops-project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]