FROM node

ENV APP=/usr/src/app
ADD . $APP

WORKDIR $APP

RUN (cd backend && yarn install) \
&&  (cd frontend && yarn install && yarn run build)

EXPOSE 1337

ENTRYPOINT ['npm', 'start']
