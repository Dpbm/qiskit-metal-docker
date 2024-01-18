# Qiskit-Metal docker

![Docker Image Version latest-ubuntu](https://img.shields.io/docker/v/dpbm32/qiskit-metal/latest-ubuntu)
![Docker Image Version latest-minimal-jupyter](https://img.shields.io/docker/v/dpbm32/qiskit-metal/latest-minimal-jupyter)
![Docker Pulls](https://img.shields.io/docker/pulls/dpbm32/qiskit-metal)
![GitHub issues](https://img.shields.io/github/issues/Dpbm/qiskit-metal-docker)
![GitHub all releases](https://img.shields.io/github/downloads/Dpbm/qiskit-metal-docker/total)
![GitHub pull requests](https://img.shields.io/github/issues-pr/Dpbm/qiskit-metal-docker)

A *community* project to run your [qiskit-metal](https://qiskit.org/metal/) project using [docker](https://www.docker.com/).

## Versions/tags

The [qiskit-metal image](https://hub.docker.com/r/dpbm32/qiskit-metal) is based on some other images.

| base image | tags   | size |
|------------|--------|------|
| [ubuntu](https://hub.docker.com/_/ubuntu) | `latest` `latest-ubuntu` | ~2Gb|
| [minimal-notebook](https://quay.io/repository/jupyter/minimal-notebook) | `latest-minimal-jupyter` | ~3Gb |

These are pretty the same thing, just with more dependencies or default tooling inside, but for qiskit-metal projects they are just the same.

## Requirements

To use these images you must have installed on your host machine:

- [Docker](https://www.docker.com/)
- [Docker compose](https://docs.docker.com/compose/) (optional)
- [xServer](https://www.x.org/wiki/) (for metal GUI)

Also set your the [`DISPLAY`](https://www.x.org/archive/X11R6.8.0/doc/X.7.html) environment variable, in case it wasn't configured before.

If you use `linux` or other `unix like`, probably you have the `X` installed and configured, otherwise you can see the [xOrg website](https://www.x.org/wiki/).
For `mac` users, you may check the [xQuartz](https://www.xquartz.org/).
And finally, for `windows` users, check the either [x410](https://x410.dev/) or [Cygwin/X](https://x.cygwin.com/).

The `X` is just required for the `metal GUI application`, so if you don't need that, just skip this step.

Finally, you may need to add the access permission to your `X server`, to do that, type:

```bash
xhost +local:root
```

and then to remove the permission, after using the docker image, you can run:

```bash
xhost -local:root
```


## Using the images

The images are available on:

| repository | build |
|------------|-------|
| [dockerHub](https://hub.docker.com/r/dpbm32/qiskit-metal) | ![dockerHub workflow](https://github.com/Dpbm/qiskit-metal-docker/actions/workflows/dockerhub.yml/badge.svg) |
| [GHRC](https://github.com/Dpbm?tab=packages&repo_name=qiskit-metal-docker) | ![GHRC workflow](https://github.com/Dpbm/qiskit-metal-docker/actions/workflows/ghrc.yml/badge.svg) |

To use them, run:

```bash
# linux example
docker run -d -v /tmp/.X11-unix:/tmp/.X11-unix:ro -e DISPLAY=$DISPLAY dpbm32/qiskit-metal:[tag]

# or (no metal GUI)
docker run -d dpbm32/qiskit-metal:[tag]
```

or

```bash
# linux example
docker run -d -v /tmp/.X11-unix:/tmp/.X11-unix:ro -e DISPLAY=$DISPLAY ghcr.io/dpbm/qiskit-metal-docker:[tag]

# or (no metal GUI)
docker run -d ghcr.io/dpbm/qiskit-metal-docker:[tag]
```

If you want a simpler way to run it, you can use the docker compose. There're two files for that:

- [default-compose.yaml](./default-compose.yaml)
- [template-compose.yaml](./template-compose.yaml)

The [default-compose.yaml](./default-compose.yaml) has the default configuration to run the image based on `Ubuntu`, and the second one is a template for those who want to add your own settings. 

This last one can be renamed for `<whatever_you_want>.yaml`.

To start the image using docker compose, run:

```bash
docker compose --project-directory ./ -f default-compose.yaml up -d

#or

docker compose --project-directory ./ -f <whatever>.yaml up -d
```


Then, access `http://<docker_ip>:8888` on your browser. If you don't know the `docker ip` run:

```bash
docker inspect <containerID> | grep IPAddress
```

---

For real projects, you might want to create a volume to save your files. To do add volumes, checkout the [official docker tutorial](https://docs.docker.com/storage/volumes/).

## Contributing

If you enjoyed our project and want to help us evolve it, you can:

- [open an issue reporting a problem/feature request](https://github.com/Dpbm/qiskit-metal-docker/issues/new)
- [solve an issue](https://github.com/Dpbm/qiskit-metal-docker/issues/)
- [check some PR](https://github.com/Dpbm/qiskit-metal-docker/pulls)
- [add a PR](https://github.com/Dpbm/qiskit-metal-docker/compare)
- complete a [todo item](https://github.com/Dpbm/qiskit-metal-docker/issues/8)

Be kind in your comments, and remember, there's another person across the monitor.
