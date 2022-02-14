FROM python:3.8-alpine
MAINTAINER J Campbell

#Env tells python to run in unbuffered mode - python prints the outputs directly
ENV PYTHONUNBUFFERED 1

#Dependencies: we will create a text file of requirements and then have it copied to our image
COPY ./requirements.txt /requirements.txt 

# install all our requiremnts
COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

#create directory for our app and change to default director
RUN mkdir /app
WORKDIR /app
COPY ./app /app

#create a user to urn our application 
# we really don't want the docker image to be run on the root account
RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
RUN chown -R user:user /vol/
RUN chmod -R 755 /vol/web
USER user


