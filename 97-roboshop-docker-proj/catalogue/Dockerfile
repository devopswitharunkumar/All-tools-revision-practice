# Basic image not optimised to less size

# FROM node:18
# EXPOSE 8080
# WORKDIR /app
# ENV MONGO=true \
#     MONGO_URL="mongodb://mongodb:27017/catalogue"
# COPY package.json .
# COPY server.js .            
# RUN npm install
# CMD [ "node", "server.js" ]




# COPY server.js .  --> server.js file copied to /app app folder eventhough u gave . because we gave WORKDIR /app all subsequentt instruction run on that folder only 



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


#In node js application node_modules,development dependencies are not required & .git directory 
#when u directly in single stage --> Everything is installed in one image: like 
    # Node.js image
    # |-- npm
    # |-- package.json
    # |-- server.js
    # |-- node_modules
    # |-- Development dependencies
    # |-- Build tools (if installed)

# Stage 1 – Builder we may have this 
# - Node.js
# - npm
# - npm install
# - node_modules
# - Build tools and dependencies


# Stage 2 – Runtime we only have required things 
# - Node.js
# - Application files
# - node_modules
# - No builder-stage tools unless copied