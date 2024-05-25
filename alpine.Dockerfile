# syntax=docker/dockerfile:1
FROM alpine:3.17.7
LABEL org.opencontainers.image.source=https://github.com/Dpbm/qiskit-metal-docker

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PIP_BREAK_SYSTEM_PACKAGES 1
ENV GDAL_VERSION 3.9.0
ENV PROJ_DIR /usr/
ENV PROJ_INCDIR ""

RUN adduser -D metal

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
                python3~3.10 \
                python3-dev \
                py3-pip \
                git \
                make \
                automake \ 
                gcc \
                g++ \
                subversion \
                py3-pyside2 \
                gfortran \
                py3-scipy \
                cython \
                py3-yaml \
                gdal \
                proj \
                proj-dev \
                proj-util \
                py3-cffi

RUN apk add --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
                gmsh \
                gmsh-py 

USER metal
ENV HOME /home/metal
ENV PATH "${HOME}/.local/bin:$PATH"
WORKDIR ${HOME}
RUN mkdir -p ${HOME}/projects

RUN python3 -m pip install pip && \
    python3 -m ensurepip --user && \
    python3 -m pip install --upgrade --user pip && \
    python3 -m pip install --upgrade --user pip setuptools wheel

RUN git clone https://github.com/Qiskit/qiskit-metal.git

WORKDIR ${HOME}/qiskit-metal
# workaround for pyside2==5.15.2.1, scipy==1.10.0, gmsh==4.11.1, pyyaml==6.0 and cython<3.0.0 installation
RUN grep -w -v -e "pyside2" -e "scipy" -e "gmsh" -e "pyyaml" -e "cython" requirements.txt > tmp.txt && \
    rm -rf requirements.txt && \
    mv tmp.txt requirements.txt
RUN pip install nbclassic jupyterhub notebook -r requirements.txt -r requirements-dev.txt -e . && \
    ipython kernel install --user --name=metal