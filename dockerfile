FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app
COPY mvnw /app/
COPY .mvn /app/.mvn
COPY pom.xml /app/
COPY src/ /app/src
RUN sed -i 's/\r$//' mvnw \
# pour remplacer les caracteres de fin de ligne qd fichier est créé sous windows (de base c \r et on les remplace par rien) le $ c pour indiquer tous les \r avant une fin de ligne. 
    && chmod +x mvnw \    
    && ./mvnw clean package -DskipTests

FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY --from=builder /app/target/*.jar /app/app.jar
CMD [ "java", "-jar", "app.jar" ]