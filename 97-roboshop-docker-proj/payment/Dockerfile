# FROM python:3.9
# EXPOSE 8080
# ENV AMQP_USER=roboshop \
#     AMQP_PASS=roboshop123
# USER root
# WORKDIR /app
# COPY requirements.txt /app/
# RUN pip install -r requirements.txt
# COPY *.py /app/
# COPY *.ini /app/
# CMD [ "uwsgi", "--ini", "payment.ini"]


FROM python:3.9.25-alpine3.22 AS build_stage
WORKDIR /app
COPY requirements.txt .
RUN apk add --no-cache --virtual .build-deps gcc musl-dev linux-headers python3-dev \
    && pip3 install --prefix=/install -r requirements.txt \
    && apk del .build-deps

FROM python:3.9.25-alpine3.22
WORKDIR /app
EXPOSE 8080
RUN addgroup -S roboshop && adduser -S -G roboshop roboshop && \
    chown -R roboshop:roboshop /app
COPY  --from=build_stage /install /usr/local
COPY --chown=roboshop:roboshop payment.ini *.py requirements.txt ./
USER roboshop
CMD ["uwsgi", "--ini", "payment.ini"]