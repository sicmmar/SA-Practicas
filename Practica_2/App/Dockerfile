# Stage 1: Build an Angular Docker Image
FROM node:16 as build
WORKDIR /practica2SA
COPY package*.json /practica2SA/
RUN npm install
COPY . /practica2SA
RUN npm run build


# Stage 2, use the compiled practica2SA, ready for production with Nginx
FROM nginx
COPY --from=build /practica2SA/dist/app /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
