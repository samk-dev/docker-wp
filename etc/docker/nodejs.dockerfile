FROM node:lts

WORKDIR /home/node/app

COPY app .

EXPOSE 3000