# Stage 1: Build Angular
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
RUN npm install -g @angular/cli
COPY . .
RUN ng build -c production

# Stage 2: Nginx
FROM nginx:alpine
# Remove default Nginx files
RUN rm -rf /usr/share/nginx/html/*
# Copy Angular build (note the /browser folder!)
COPY --from=build /app/dist/devproject/browser/ /usr/share/nginx/html/
# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Ensure permissions
RUN chmod -R 755 /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
