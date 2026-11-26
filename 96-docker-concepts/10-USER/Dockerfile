
FROM redhat/ubi9:latest
RUN apt-get update
RUN apt-get install -y nginx
#-m ---> it will create the home directory of that user 
RUN useradd -m roboshop      
USER roboshop
CMD ["nginx", "-g", "daemon off;"]