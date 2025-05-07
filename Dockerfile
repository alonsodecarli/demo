FROM maven:3.9.9 AS build

WORKDIR /app

COPY ./pom.xml ./pom.xml
COPY ./src ./src

RUN mvn clean package

FROM openjdk:21-jdk-slim

RUN useradd -ms /bin/bash appuser
USER appuser

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar
#COPY opentelemetry-javaagent.jar opentelemetry-javaagent.jar

#ARG ACTIVE_PROFILE=prod
#ENV SPRING_PROFILES_ACTIVE=${ACTIVE_PROFILE}

#ENV OTEL_SERVICE_NAME="viahelper-gateway"
#ENV OTEL_EXPORTER_OTLP_ENDPOINT="http://collector.monitoramento:4318"
#ENV OTEL_LOGS_EXPORTER=otlp
#ENV OTEL_METRICS_EXPORTER=otlp
#ENV OTEL_TRACES_EXPORTER=otlp

EXPOSE 8080
#ENTRYPOINT ["java", "-javaagent:opentelemetry-javaagent.jar", "-jar", "app.jar"]
ENTRYPOINT ["java", "-jar", "app.jar"]
