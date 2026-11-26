FROM redhat/ubi9:latest
RUN yum install nginx -y 
RUN rm -rf /usr/share/nginx/html/
COPY index.html /usr/share/nginx/html/
CMD ["nginx","-g","daemon off;"]