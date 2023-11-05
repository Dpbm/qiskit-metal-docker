# syntax=docker/dockerfile:1
FROM ubuntu:latest
ENV LANG en_US.utf8

RUN apt update && apt install tzdata -y
ENV TZ="America/New_York"

ENV PYTHON_VERSION=3.10

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

ENV HOME home/
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv && \
    pyenv install $PYTHON_VERSION && \
    pyenv global $PYTHON_VERSION && \
    pyenv rehash

RUN pip install --upgrade pip && \
    pip install jupyterlab ipython PySide2 qiskit-metal && \
    git clone https://github.com/Qiskit/qiskit-metal.git && \
    cd qiskit-metal && \
    pip install -r requirements.txt -r requirements-dev.txt -e .

CMD ["jupyter", "lab"]
EXPOSE 8888

