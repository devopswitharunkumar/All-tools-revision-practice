#
# Build stage after Compilation this stage will be discarded 
#

FROM maven:3.9.16-eclipse-temurin-17 AS build_stage
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn dependency:resolve
RUN mvn clean package -DskipTests


# RUN stage this will be packed as image 
FROM eclipse-temurin:17-jre-alpine
EXPOSE 8080
WORKDIR /app
COPY --from=build_stage /app/target/shipping-1.0.jar shipping.jar 
ENTRYPOINT [ "java", "-jar" ]
CMD [ "shipping.jar" ]