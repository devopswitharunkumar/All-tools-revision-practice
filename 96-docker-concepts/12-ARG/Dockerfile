FROM redhat/ubi9:latest
ARG username 
RUN adduser ${username}
USER ${username}
CMD [ "sleep", "100" ]

# username ---> variable name i.e., key 
#Run  --. docker build -t arg:v1 --build-arg username=arun .

# # Using ARG variable before FROM instruction 
# ARG version=latest
# FROM redhat/ubi9:${version}
# ARG username 
# RUN adduser ${username}
# USER ${username}
# CMD [ "sleep", "100" ]

# # username ---> variable name i.e., key 

#run --> docker build --build-arg username=arun -t <imagename:tag> .   ---> if u use default version mention in this file ie, latest 
#run --> docker build --build-arg version=9.9 --build-arg username=arun -t <imagename:tag> .   ---> if u use override version mention in this file i.e., latest at runtime 

# # Using ARG + ENV variable CPmbination 
# FROM redhat/ubi9:latest
# ARG username
# RUN adduser ${username}
# USER ${username}

# #combination ARG and ENV below 4 steps 
# ARG COURSE 
# ARG DURATION
# ENV course=${COURSE}
# ENV duration=${DURATION}
# RUN echo "course = ${COURSE} and duration= ${DURATION}"
# CMD [ "sleep", "100" ]

# #run --> docker build --build-arg username=arun --build-arg COURSE="DevOps" --build-arg DURATION=4months -t <imagename:tag> .