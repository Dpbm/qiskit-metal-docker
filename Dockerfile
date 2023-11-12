# syntax=docker/dockerfile:1
FROM ubuntu:latest

ENV LANG en_US.utf8
ENV TZ="America/New_York"

RUN apt update && apt upgrade -y

USER metal
ENV HOME /home/metal
ENV ENV_PATH ${HOME}/env
WORKDIR ${HOME}