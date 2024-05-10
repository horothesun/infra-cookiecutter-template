#!/bin/bash

DOCKER_IMAGE_TAG="tf-config-inspect"

docker build --tag "${DOCKER_IMAGE_TAG}" "."

ALL_TERRAFORM_VERSIONS=$( docker run --rm --volume ".:/go/external" "${DOCKER_IMAGE_TAG}" )

echo "ALL_TERRAFORM_VERSIONS: ${ALL_TERRAFORM_VERSIONS}"

TERRAFORM_VERSION=$( echo "${ALL_TERRAFORM_VERSIONS}" | jq --raw-output '.terraform_version' )
echo "TERRAFORM_VERSION: ${TERRAFORM_VERSION}"
export TERRAFORM_VERSION

TERRAFORM_AWS_VERSION=$( echo "${ALL_TERRAFORM_VERSIONS}" | jq --raw-output '.terraform_aws_version' )
echo "TERRAFORM_AWS_VERSION: ${TERRAFORM_AWS_VERSION}"
export TERRAFORM_AWS_VERSION
