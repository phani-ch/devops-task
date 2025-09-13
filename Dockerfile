# Use Node.js official image
FROM node:18-alpine

# Set working directory inside container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy all app files into container
COPY . .

# Expose the port your app uses
EXPOSE 3000

# Command to run your app
CMD ["node", "app.js"]

