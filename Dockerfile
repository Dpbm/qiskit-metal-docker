# syntax=docker/dockerfile:1
FROM quay.io/jupyter/minimal-notebook

ENV LANG en_US.utf8
ENV TZ="America/New_York"

USER root
RUN groupadd -r metal && useradd -r -g metal metal
RUN apt update && apt upgrade -y && apt install -y build-essential

USER metal
ENV HOME /home/metal
ENV PATH "${HOME}/.local/bin:$PATH"
WORKDIR ${HOME}
RUN mkdir -p ${HOME}/projects

RUN git clone https://github.com/Qiskit/qiskit-metal.git
WORKDIR ${HOME}/qiskit-metal
RUN conda env create -n metal -f environment.yml
RUN conda activate metal && \
    python -m pip install --no-deps -e . && \
    ipython kernel install --user --name=metal

WORKDIR ${HOME}/projects
RUN mv ${HOME}/qiskit-metal/tutorials ${HOME}/projects


CMD ["jupyter", "lab", "--debug", "--ip", "0.0.0.0", "--port", "8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
EXPOSE 8888