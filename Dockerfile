ARG RUNTIME_IMAGE=adoptopenjdk/openjdk11:jdk-11.0.6_10-alpine-slim
ARG BUILD_IMAGE=maven:3.6.0-jdk-11
ARG JAR_FILE=target/*.jar
FROM ${BUILD_IMAGE} AS builder
WORKDIR /app
COPY . ./
COPY pom.xml .
RUN mvn clean package
COPY . ./
FROM ${RUNTIME_IMAGE}
WORKDIR /app
RUN set -eux; \
    addgroup -S -g 1000 spring; \
    adduser -S -D -u 1000 -G spring spring;
USER spring
COPY --from=builder /app/${JAR_FILE} ./app.jar
EXPOSE 9000
ENTRYPOINT [ "java", "-jar", "./app.jar" ]