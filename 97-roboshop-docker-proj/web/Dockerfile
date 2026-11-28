
FROM nginx:latest
RUN rm -rf /usr/share/nginx/html/*
RUN rm -f /etc/nginx/nginx.conf \
    /etc/nginx/conf.d/default.conf
COPY roboshop.conf /etc/nginx/nginx.conf
COPY static/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
