FROM nginx:stable-alpine

# Copy custom index file
COPY index.html /usr/share/nginx/html/index.html

# Install additional tools if needed (curl and nano)
RUN apk add --no-cache curl nano

# Expose port 80
EXPOSE 80

# Nginx runs automatically in the foreground in this image
CMD ["nginx", "-g", "daemon off;"]