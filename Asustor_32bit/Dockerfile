FROM ioft/i386-ubuntu:14.04

MAINTAINER colin.lin@orbweb.com

ARG path

ARG compile

RUN mkdir -p /home/colin/git_home

WORKDIR /home/colin/git_home

RUN apt-get update && apt-get install -y \
    ssh gcc g++ m4 autoconf automake libtool make cmake git expect

RUN wget ftp://XXX.XXX.XXX.XXX/asustor/arm-marvell-linux-gnueabi_glibc2.22.tar.gz --ftp-user="XXXXX" --ftp-password="XXXXX"

RUN wget ftp://XXX.XXX.XXX.XXX/asustor/i686-asustor-linux-gnu.tar.gz --ftp-user="XXXXX" --ftp-password="XXXXX"

RUN wget ftp://XXX.XXX.XXX.XXX/asustor/x86_64-asustor-linux-gnu.tar.gz --ftp-user="XXXXX" --ftp-password="XXXXX"

RUN tar -zxvf /home/colin/git_home/arm-marvell-linux-gnueabi_glibc2.22.tar.gz

RUN tar -zxvf /home/colin/git_home/i686-asustor-linux-gnu.tar.gz

RUN tar -zxvf /home/colin/git_home/x86_64-asustor-linux-gnu.tar.gz

ENV CROSS_COMPILE=$compile

ENV CROSS_PATH=$path

ENV AR="${CROSS_PATH}ar"

ENV CC="${CROSS_PATH}gcc"

ENV CPP="${CROSS_PATH}cpp"

ENV CXX="${CROSS_PATH}g++"

ENV LD="${CROSS_PATH}ld"

ENV NM="${CROSS_PATH}nm"

ENV RANLIB="${CROSS_PATH}ranlib"

ENV STRIP="${CROSS_PATH}strip"
