FROM golang:1.22.3

RUN apt-get update && apt-get install --yes jq vim

# https://pkg.go.dev/github.com/hashicorp/terraform-config-inspect?tab=versions
RUN go install github.com/hashicorp/terraform-config-inspect@v0.0.0-20240509232506-4708120f8f30

CMD external/scripts/run_from_docker_container.sh
