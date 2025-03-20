# Usamos la imagen oficial de Maven para compilar y empaquetar la aplicación
FROM maven:3.8.6-eclipse-temurin-17 AS builder

# Establecemos el directorio de trabajo
WORKDIR /app

# Copiamos el archivo pom.xml y las dependencias
COPY pom.xml .

# Descargamos las dependencias para que se almacenen en caché si no han cambiado
RUN mvn dependency:resolve

# Copiamos el resto del código fuente de la aplicación
COPY . .

# Construimos el paquete de la aplicación
RUN mvn clean package -DskipTests

# -----------------------
# Imagen para producción
# -----------------------

# Usamos una imagen ligera de Java para producción
FROM openjdk:17-jdk-slim

# Directorio donde se copiará el archivo .jar
WORKDIR /app

# Copiamos el archivo .jar generado por Maven desde la imagen anterior
COPY --from=builder /app/target/*.jar app.jar

# Exponemos el puerto en el que correrá la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "app.jar"]
#sergio