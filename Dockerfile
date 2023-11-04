# syntax=docker/dockerfile:1
FROM ubuntu:latest
ENV LANG en_US.utf8
RUN apt update && apt install tzdata -y
ENV TZ="America/New_York"
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential python3-pip libssl-dev libffi-dev python3-dev python3-tk
