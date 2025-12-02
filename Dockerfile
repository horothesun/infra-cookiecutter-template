FROM golang:1.25.5

RUN apt-get update && apt-get install --yes jq

# https://pkg.go.dev/github.com/hashicorp/terraform-config-inspect?tab=versions
RUN go install github.com/hashicorp/terraform-config-inspect@v0.0.0-20250401063509-d2d12f9a63bb

CMD external/scripts/get_terraform_versions_json.sh external
