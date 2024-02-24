FROM node:alpine as build

WORKDIR /app

COPY . /app

RUN npm install

RUN npm run build

FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 for the Nginx server
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]

