# syntax=docker/dockerfile:1
FROM ubuntu:latest
ENV LANG en_US.utf8

RUN apt update && apt install tzdata -y
ENV TZ="America/New_York"

ENV PYTHON_VERSION=3.10.13

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
RUN groupadd -r metal && useradd -r -g metal metal

RUN curl https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz -O && \
    tar -xvf Python-$PYTHON_VERSION.tar.xz && \
    rm -rf *.tar.xz && \
    cd Python-$PYTHON_VERSION && \
    ./configure && \
    make && \
    make install

USER metal
WORKDIR /home/metal
ENV HOME /home/metal

RUN python3 -m ensurepip --upgrade && \
    python3 -m pip install --upgrade pip && \
    curl https://bootstrap.pypa.io/pip/pip.pyz -O

ENV PIP "python3 $HOME/pip.pyz"
ENV PATH "$HOME/.local/bin:$PATH"

RUN $PIP install setuptools wheel
RUN $PIP install jupyterlab ipython PySide2 qiskit-metal ipykernel && \
    git clone https://github.com/qiskit-community/qiskit-metal/ && \
    git clone https://github.com/qiskit-community/intro-to-quantum-computing-and-quantum-hardware && \
    cd qiskit-metal && \
    $PIP install -r requirements.txt -r requirements-dev.txt -e . && \
    ipython kernel install --user --name=metal && \
    cd ..

RUN mkdir projects && mv ./qiskit-metal/tutorials projects && mv ./intro-to-quantum-computing-and-quantum-hardware projects
WORKDIR projects

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--port", "8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
EXPOSE 8888

