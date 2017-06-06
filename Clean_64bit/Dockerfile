FROM orbweb/ubuntu64:v1

MAINTAINER colin.lin@orbweb.com

ARG path

ARG compile

ARG download

ARG filename

RUN mkdir -p /home/colin/git_home

WORKDIR /home/colin/git_home

RUN wget $download

RUN tar -zxvf /home/colin/git_home/$filename

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
