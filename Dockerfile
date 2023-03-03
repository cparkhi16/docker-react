# multi steps builds (Builder phase)
FROM node:16-alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# run phase (dev server(nginx) we need for prod env as we don't have dev server on prod env)
FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html

# here we have 2 phases : - builder and run phase , in build phase we will build a container which will have a build dir after running
# npm run build inside the container and which is only important for our application to start up
# notice that from builder phase we just copy that build dir from app dir and we don't copy anything else there by reducing our image size and start our nginx server using-
# docker run -p 8080:80 <image-id> 