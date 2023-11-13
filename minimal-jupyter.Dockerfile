# syntax=docker/dockerfile:1
FROM quay.io/jupyter/minimal-notebook

ENV LANG en_US.utf8
ENV TZ="America/New_York"

USER root
RUN groupadd -r metal && useradd -r -g metal metal
RUN apt update && \
    apt upgrade -y && \
    apt install -y build-essential \
        libgl1-mesa-glx \
        libglu1-mesa \ 
        libxcursor-dev \ 
        libxft2 \ 
        libxinerama1 \
        libexpat1

USER metal
ENV HOME /home/metal
ENV PATH "${HOME}/.local/bin:$PATH"
WORKDIR ${HOME}
RUN mkdir -p ${HOME}/projects

RUN git clone https://github.com/Qiskit/qiskit-metal.git
WORKDIR ${HOME}/qiskit-metal
RUN conda env create -n metal -f environment.yml &&\
    source activate metal && \
    python -m pip install --no-deps -e . && \
    ipython kernel install --user --name=metal

USER metal
WORKDIR ${HOME}/projects
RUN git clone https://github.com/qiskit-community/intro-to-quantum-computing-and-quantum-hardware/ && \
    mv ${HOME}/qiskit-metal/tutorials ${HOME}/projects

CMD ["conda", "run", "-n", "metal", "jupyter", "lab", "--debug", "--ip", "0.0.0.0", "--port", "8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
EXPOSE 8888
