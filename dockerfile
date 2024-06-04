#pull base image
FROM node:lts-alpine3.20


#install global packages
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk
ENV PATH=$PATH:/usr/lib/android-sdk/platform-tools/

# Set the working directory to /app
WORKDIR /app

# Copy the package.json file
COPY package*.json ./


# Copy the current directory contents into the container at /app
COPY . .

# Install dependencies
RUN npm install

# Install react-native-cli
#RUN npm install -g react-native-cli

# Start the React Native server
CMD ["npm","run", "start"]