#!/bin/bash

TERRAFORM_PROD_DIR=external source external/scripts/get_terraform_versions.sh
external/scripts/edit_cookiecutter_json.sh "external/cookiecutter.json"
