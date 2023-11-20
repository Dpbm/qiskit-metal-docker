# syntax=docker/dockerfile:1
FROM alpine:3.15

RUN addgroup -S metal && adduser -S metal -G metal
RUN apk add git \
    python3 \
    python3-dev \ 
    build-base \
    cmake \
    qt5-qtbase \
    qt5-qtbase-dev \
    clang \
    clang-dev \
    libxml2 \
    libxslt \
    libxslt-dev \
    llvm12 \
    llvm12-dev \
    gfortran \
    openblas \
    openblas-dev \
    py3-wheel \
    py3-setuptools \
    py3-pip \
    sphinx \
    py3-sphinx \
    py3-pyside2 \
    py3-scipy \
    py3-numpy \
    py3-matplotlib \
    py3-pandas \
    py3-yaml \
    gdal \
    py3-gdal \
    gdal-dev \ 
    proj-util \
    musl-dev

WORKDIR /tmp
COPY requirements-alpine.txt .
RUN python3 -m pip install -r requirements-alpine.txt && \
    git clone https://github.com/qiskit-community/qiskit-metal.git && \
    rm -rf requirements-alpine.txt
WORKDIR /qiskit-metal
RUN ipython kernel install --user --name=metal

USER metal
ENV HOME /home/metal
RUN mkdir -p ${HOME}/projects
WORKDIR ${HOME}/projects
RUN git clone https://github.com/qiskit-community/intro-to-quantum-computing-and-quantum-hardware && \
    mv /qiskit-metal/tutorials . && \
    rm -rf /tmp/qiskit-metal

CMD ["jupyter", "lab", "--debug", "--ip", "0.0.0.0", "--port", "8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
EXPOSE 8888

