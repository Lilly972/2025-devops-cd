# --- Stage 1: Build ---
# On change l'image de base pour une image qui contient déjà MAVEN
FROM maven:3.9.9-eclipse-temurin-21-alpine AS builder

WORKDIR /app

# On copie d'abord le pom.xml pour les dépendances
COPY pom.xml .

# On télécharge les dépendances (plus besoin de ./mvnw, on utilise la commande 'mvn' directe)
RUN mvn dependency:go-offline

# On copie les sources
COPY src ./src

# On lance la compilation avec mvn directement
RUN mvn clean package -DskipTests

# --- Stage 2: Run (Ça ne change pas) ---
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# On récupère le jar depuis l'étape précédente
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]