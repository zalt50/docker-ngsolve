FROM ubuntu:latest

WORKDIR /home/app
        
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
                
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository universe
RUN add-apt-repository ppa:ngsolve/nightly -y
RUN apt-get install ngsolve -y
        
RUN apt-get install -y cmake git python3-pip
RUN pip3 install --no-cache-dir notebook==5.*
            
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

                
                