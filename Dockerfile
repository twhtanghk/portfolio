FROM node

ENV APP=/usr/src/app
ADD . $APP

WORKDIR $APP

RUN (cd backend && yarn install) \
&& (cd frontend && yarn install --network-concurrency 1)

EXPOSE 1337

CMD (cd backend && yarn start)
