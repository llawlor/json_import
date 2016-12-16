# create an image: docker build -t json_import .
# connect to the image: docker run -i -t json_import /bin/bash

# get the correct ruby version
FROM ruby:2.2.2

# update the system
RUN apt-get update -qq && apt-get install -y build-essential

# copy the current directory to /u/apps/json_import
COPY . /u/apps/json_import

# use this as the working directory
WORKDIR /u/apps/json_import

# install gems
RUN bundle install
