FROM maven AS build
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
COPY src ./src
RUN ./mvnw clean package -DskipTests
EXPOSE 80
CMD ["java", "-jar", "target/myapp.jar"]