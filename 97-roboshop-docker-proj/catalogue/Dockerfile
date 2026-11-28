FROM node:18
EXPOSE 8080
WORKDIR /app
ENV MONGO=true \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
COPY package.json .
COPY server.js .            
RUN npm install
CMD [ "node", "server.js" ]




# COPY server.js .  --> server.js file copied to /app app folder eventhough u gave . because we gave WORKDIR /app all subsequentt instruction run on that folder only 



# FROM node:20.20.2-alpine3.22 AS builder
# # creates /app and set the directory to /app
# WORKDIR /app
# COPY package.json .
# COPY *.js .
# # node_modules
# RUN npm install 

# FROM node:20.20.2-alpine3.22
# WORKDIR /app
# EXPOSE 8080
# ENV MONGO="true" \
#     MONGO_URL="mongodb://mongodb:27017/catalogue"
# RUN addgroup -S roboshop && adduser -S -G roboshop roboshop && \
#     chown -R roboshop:roboshop /app
# COPY --from=builder /app /app
# USER roboshop
# CMD ["node", "server.js"]