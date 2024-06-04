# Use an official Node runtime as a parent image
FROM node:lts-alpine3.20

# Install required dependencies for React Native
RUN apk add --no-cache bash openjdk17-jdk android-tools wget unzip

# Set environment variables for Android SDK and Java
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools:$JAVA_HOME/bin

# Download and install Android SDK command line tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip -O android-tools.zip && \
    mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    unzip -q android-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    rm android-tools.zip

# Install Android SDK packages and accept licenses
RUN yes | $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager --licenses && \
    $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager "platforms;android-29" "build-tools;29.0.3"

# Manually download and install Android NDK
RUN wget -q https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip -O android-ndk.zip && \
    unzip -q android-ndk.zip -d /usr/lib/android-sdk && \
    rm android-ndk.zip && \
    ln -s /usr/lib/android-sdk/android-ndk-r21e /usr/lib/android-sdk/ndk-bundle

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
CMD ["npm", "start"]
