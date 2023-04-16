# Use Node 16 alpine as parent image
FROM node:19-slim

# Change the working directory on the Docker image to /app
WORKDIR /blog

# Copy the rest of project files into this image
COPY . .

RUN npm install

# Expose application port
EXPOSE 3000

# Start the application
CMD npm run dev
