# Parent image 
FROM redhat/ubi9:latest
RUN yum install -y nginx 
RUN rm -rf /usr/share/nginx/html/index.html 
ONBUILD ADD index.html /usr/share/nginx/html/
CMD [ "nginx", "-g", "off;" ]