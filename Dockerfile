FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Copy only the package files first
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Explicitly copy ONLY your app code (Fixes the COPY . . warning)
COPY app.js ./

# Switch to the restricted 'node' user (Fixes the root user warning)
USER node

# Expose the port
EXPOSE 3000

# Start the application
CMD ["node", "app.js"]