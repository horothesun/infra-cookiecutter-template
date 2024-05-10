#!/bin/bash

DOCKER_IMAGE_TAG="tf-config-inspect"

docker build --tag "${DOCKER_IMAGE_TAG}" "."

ALL_TERRAFORM_VERSIONS=$( docker run --rm --volume ".:/go/external" "${DOCKER_IMAGE_TAG}" )

echo "ALL_TERRAFORM_VERSIONS: ${ALL_TERRAFORM_VERSIONS}"

TERRAFORM_VERSION=$( echo "${ALL_TERRAFORM_VERSIONS}" | jq --raw-output '.terraform_version' )
export TERRAFORM_VERSION
echo "TERRAFORM_VERSION: ${TERRAFORM_VERSION}"

TERRAFORM_AWS_VERSION=$( echo "${ALL_TERRAFORM_VERSIONS}" | jq --raw-output '.terraform_aws_version' )
export TERRAFORM_AWS_VERSION
echo "TERRAFORM_AWS_VERSION: ${TERRAFORM_AWS_VERSION}"
