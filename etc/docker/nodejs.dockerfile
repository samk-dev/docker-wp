FROM node:lts

WORKDIR /home/node/app

RUN chmod 777 /home/node/app

EXPOSE 3000