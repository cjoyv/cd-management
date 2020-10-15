FROM python:3.6-alpine AS build-image

ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /cr8rel

COPY . /cr8rel/

RUN apk add --update --no-cache git gcc libc-dev libffi-dev openssl-dev libmagic
RUN pip install pybuilder==0.11.17
RUN pyb install_dependencies
RUN pyb
RUN pyb publish


FROM python:3.6-alpine

ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /opt/cr8rel

COPY --from=build-image /cr8rel/target/dist/cr8rel-*/dist/cr8rel-*.tar.gz /opt/cr8rel

# the following lines are necessary because github3api isn't yet published to PyPi
# once it is published then the following lines will be removed
RUN apk add --update --no-cache git gcc libc-dev libffi-dev openssl-dev libmagic
RUN pip install git+https://github.com/soda480/github3api.git@master#egg=github3api

RUN pip install cr8rel-*.tar.gz

CMD echo 'DONE'
