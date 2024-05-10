#!/bin/bash

DOCKER_IMAGE_TAG="tf-config-inspect"

docker build --tag "${DOCKER_IMAGE_TAG}" "."
docker run --rm --volume ".:/go/external" "${DOCKER_IMAGE_TAG}"
