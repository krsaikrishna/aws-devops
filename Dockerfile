# Base image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy app files
COPY . .

# Expose app port
EXPOSE 3000

# Start app
CMD ["npm", "start"]

