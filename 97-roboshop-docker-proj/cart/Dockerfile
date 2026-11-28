FROM nodejs:18
EXPOSE 8080
WORKDIR /app
ENV MONGO=true \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
COPY *.json /app/ \
     *.js /app/
RUN npm install 
CMD [ "node", "server.js" ]
