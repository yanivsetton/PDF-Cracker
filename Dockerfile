FROM ubuntu:latest
MAINTAINER Yaniv Setton
WORKDIR /opt
RUN apt-get update && \
      apt-get -y install sudo && \
      apt-get install python3-pip -y
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN echo "docker ALL=(ALL:ALL) ALL" >> /etc/sudoers
COPY . .
RUN pip3 install -r requirements.txt
RUN sudo chmod a+x ./pdforce.py
ENTRYPOINT python3 ./pdforce.py $1 $2 $3