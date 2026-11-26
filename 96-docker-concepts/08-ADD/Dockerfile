FROM redhat/ubi9:latest
RUN yum install nginx -y 
ADD https://github.com/devopswitharunkumar/roboshop-ansible-with-roles-for-CD-deploy-usage/blob/main/variables-prod.yaml /tmp/
ADD sample-1.tar /tmp/
CMD ["nginx","-g","daemon off;"]