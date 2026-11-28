# FROM node:18
# EXPOSE 8080
# WORKDIR /app
# ENV MONGO=true \
#     MONGO_URL="mongodb://mongodb:27017/catalogue"
# COPY *.json ./ \
#      *.js ./
# RUN npm install 
# CMD [ "node", "server.js" ]




FROM node:18.5.0-alpine3.16 AS builder
# creates /app and change the directory to /app
WORKDIR /app
COPY package.json .
COPY *.js .
# node_modules
RUN npm install 

FROM node:18.5.0-alpine3.16
WORKDIR /app
EXPOSE 8080
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
RUN addgroup -S roboshop && adduser -S -G roboshop roboshop && \
    chown -R roboshop:roboshop /app
COPY --from=builder /app /app
USER roboshop
CMD ["node", "server.js"]