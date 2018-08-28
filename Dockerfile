FROM photoflow/docker-centos7-gtk

RUN mkdir -p /$AIPREFIX/bin && mkdir -p /work
COPY build-dependencies.sh /work

RUN cd /work && bash ./build-dependencies.sh

RUN rm -rf /work/build
