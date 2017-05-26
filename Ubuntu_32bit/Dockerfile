FROM ioft/i386-ubuntu:14.04

MAINTAINER colin.lin@orbweb.com

RUN mkdir -p /home/colin/git_home

WORKDIR /home/colin/git_home

RUN apt-get update && apt-get install -y \
    ssh gcc g++ m4 autoconf automake libtool make cmake git expect
