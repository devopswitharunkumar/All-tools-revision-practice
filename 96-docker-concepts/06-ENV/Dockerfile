FROM redhat/ubi9:latest
RUN yum install nginx -y 
LABEL course="DevOps"
LABEL months="6"
LABEL trainer="siva"
EXPOSE 80
ENV APP_PORT=80 \
    ENVIRONMENT=dev \
    LOG_LEVEL=INFO
CMD ["nginx","-g","daemon off;"]