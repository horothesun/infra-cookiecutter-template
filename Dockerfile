FROM golang:1.22.3

RUN apt-get update && apt-get install --yes jq vim
RUN go install github.com/hashicorp/terraform-config-inspect@v0.0.0-20231204233900-a34142ec2a72

CMD external/scripts/run_from_docker_container.sh
