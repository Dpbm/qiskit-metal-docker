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
    llvm12-dev

RUN ln -s /usr/lib/qt5/bin/* /usr/bin 

RUN python3 -m ensurepip --upgrade && \
    python3 -m pip install --upgrade pip wheel setuptools

WORKDIR /tmp
RUN git clone https://code.qt.io/pyside/pyside-setup
WORKDIR /tmp/pyside-setup
RUN git submodule update --init --recursive && \
    git branch --track 5.15.2 origin/5.15.2 && \
    git checkout 5.15.2 && \
    python3 setup.py install --qmake=/usr/lib/qt5/bin/qmake --cmake=/usr/bin/cmake --parallel=8
WORKDIR /tmp
RUN rm -rf /pyside-setup

WORKDIR /
RUN git clone https://github.com/qiskit-community/qiskit-metal.git
WORKDIR /qiskit-metal
RUN apk add gfortran openblas openblas-dev gmsh && \
    python3 -m pip install -r requirements.txt -r requirements-dev.txt -e . && \
    ipython kernel install --user --name=metal

USER metal
ENV HOME /home/metal
RUN mkdir -p ${HOME}/projects
WORKDIR ${HOME}/projects
RUN git clone https://github.com/qiskit-community/intro-to-quantum-computing-and-quantum-hardware && \
    mv /qiskit-metal/tutorials .

CMD ["jupyter", "lab", "--debug", "--ip", "0.0.0.0", "--port", "8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
EXPOSE 8888

