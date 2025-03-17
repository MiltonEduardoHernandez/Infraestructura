# Usa una imagen oficial de Maven para construir el proyecto
FROM maven:3.8.1-openjdk-11 AS build

WORKDIR /app
COPY . .

# Compila el proyecto y genera el .jar
RUN mvn clean package

# Usa una imagen de Java para ejecutar la aplicación
FROM openjdk:11-jre-slim

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Ejecuta la aplicación
CMD ["java", "-jar", "app.jar"]

