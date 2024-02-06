# Use an official Maven runtime as a parent image
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project file
COPY ./pom.xml .

# Download all required dependencies into the container
RUN mvn dependency:go-offline -B

# Copy the project source code
COPY ./src ./src

# Package the application
RUN mvn package -DskipTests

# Use a smaller base image for the runtime
FROM adoptopenjdk:11-jre-hotspot

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the build stage to the new image
COPY --from=build /app/target/*.jar ./app.jar

# Specify the command to run on container start
CMD ["java", "-jar", "./app.jar"]
