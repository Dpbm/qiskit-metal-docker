# syntax=docker/dockerfile:1
FROM ubuntu:latest

RUN apt update && apt install tzdata -y

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.utf8
ENV TZ="America/New_York"
ENV PYTHON_VERSION=3.10.13

RUN apt upgrade -y && \
    apt install -y xorg x11-apps git build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
RUN groupadd -r metal && useradd -r -g metal metal

WORKDIR /tmp
RUN curl https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz -O && \
    tar -xvf ./Python-$PYTHON_VERSION.tar.xz && \
    rm -rf *.tar.xz 
WORKDIR /tmp/Python-$PYTHON_VERSION
RUN ./configure && make && make install
WORKDIR /tmp
RUN rm -rf ./Python-$PYTHON_VERSION

USER metal
ENV HOME /home/metal
ENV PATH "$HOME/.local/bin:$PATH"
WORKDIR $HOME

RUN python3 -m pip install --upgrade pip setuptools wheel
RUN git clone https://github.com/qiskit-community/qiskit-metal.git ./qiskit-metal && \
    git clone https://github.com/qiskit-community/intro-to-quantum-computing-and-quantum-hardware.git ./intro-to-quantum-computing-and-quantum-hardware
WORKDIR $HOME/qiskit-metal
RUN pip install ipython ipykernel && \
    ipython kernel install --user --name=metal && \
    python3 -m pip install -r requirements.txt -r requirements-dev.txt -e .
WORKDIR $HOME
ENV PATH "$HOME/qiskit-metal:$PATH"
RUN mkdir projects && \
    mv ./qiskit-metal/tutorials ./projects && \
    mv ./intro-to-quantum-computing-and-quantum-hardware ./projects && \
    rm -rf ./intro-to-quantum-computing-and-quantum-hardware
WORKDIR $HOME/projects

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--port", "8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
EXPOSE 8888

