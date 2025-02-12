FROM golang:1.24.0

RUN apt-get update && apt-get install --yes jq

# https://pkg.go.dev/github.com/hashicorp/terraform-config-inspect?tab=versions
RUN go install github.com/hashicorp/terraform-config-inspect@v0.0.0-20241129133400-c404f8227ea6

CMD external/scripts/get_terraform_versions_json.sh external
