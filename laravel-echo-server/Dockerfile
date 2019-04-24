FROM node:alpine

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/

# sed: /etc/apt/sources.list: No such file or directory， get a error
#RUN sed -i "s/archive.ubuntu./mirrors.aliyun./g" /etc/apt/sources.list && \
#    sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list && \
#    sed -i "s/security.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base

RUN npm install

# Bundle app source
COPY laravel-echo-server.json /usr/src/app/laravel-echo-server.json

EXPOSE 3000
CMD [ "npm", "start", "--force" ]
