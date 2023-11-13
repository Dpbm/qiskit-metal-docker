# syntax=docker/dockerfile:1
FROM ubuntu:latest

ENV LANG en_US.utf8
ENV TZ="America/New_York"
ENV DEBIAN_FRONTEND noninteractive
ENV XDG_RUNTIME_DIR /tmp/runtime-metal

RUN groupadd -r metal && useradd -r -g metal metal
RUN apt update && \
    apt upgrade -y && \
    apt install -y git \
    python3.10 \
    python3-pip \
    build-essential \
    libglib2.0-0 \
    libgl1-mesa-glx \
    libglu1-mesa \ 
    libxcursor-dev \ 
    libxft2 \ 
    libxinerama1 \
    libexpat1 \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    pandoc \ 
    qtbase5-dev \ 
    qtchooser \ 
    qt5-qmake \
    qtbase5-dev-tools

USER metal
ENV HOME /home/metal
ENV PATH "${HOME}/.local/bin:$PATH"
WORKDIR ${HOME}
RUN mkdir -p ${HOME}/projects

RUN git clone https://github.com/Qiskit/qiskit-metal.git
WORKDIR ${HOME}/qiskit-metal
RUN python3.10 -m pip install nbclassic jupyterhub notebook -r requirements.txt -r requirements-dev.txt -e . && \
    ipython kernel install --user --name=metal

USER metal
WORKDIR ${HOME}/projects
RUN git clone https://github.com/qiskit-community/intro-to-quantum-computing-and-quantum-hardware/ && \
    mv ${HOME}/qiskit-metal/tutorials ${HOME}/projects

CMD ["jupyter", "lab", "--debug", "--ip", "0.0.0.0", "--port", "8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
EXPOSE 8888
