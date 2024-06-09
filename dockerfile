# Use an official Node runtime as a parent image
FROM node:lts-alpine3.20

# Install required dependencies for React Native
RUN apk add --no-cache bash android-tools

# Set environment variables for Android SDK and Java
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools:$JAVA_HOME/bin

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Install react-native-cli
RUN npm install -g react-native-cli

# Expose the Metro Bundler port
EXPOSE 8081

# Start the React Native server
CMD ["npm", "run","start"]
