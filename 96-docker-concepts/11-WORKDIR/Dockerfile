# without WORKDIR usage

# FROM redhat/ubi9:latest
# RUN cd /tmp 
# RUN echo "Hello Docker" > hello.txt
# CMD ["sleep", "100"]

#file will not be created on /tmp folder instead it will create in root folder
#if u want to run inside /tmp u need to write like below cd /app in each instruction



# with WORKDIR usage
FROM redhat/ubi9:latest
RUN apt-get update
WORKDIR /app 
#check this below file in /app folder 
RUN echo "Hello Docker With WORKDIR Instruction usage" > hello.txt
RUN apt-get install -y nginx
#-m ---> it will create the home directory of that user 
RUN useradd -m roboshop      
USER roboshop
CMD ["nginx", "-g", "daemon off;"]