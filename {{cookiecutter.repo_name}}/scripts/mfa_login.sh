#!/bin/bash

MFA_OTP="$1"

if [[ -z "${AWS_REGION}" ]] ; then
  echo "Error: AWS_REGION must be passed defined"
elif [[ -z "${AWS_DEFAULT_REGION}" ]] ; then
  echo "Error: AWS_DEFAULT_REGION must be passed defined"
elif [[ -z "${AWS_ACCESS_KEY_ID}" ]] ; then
  echo "Error: AWS_ACCESS_KEY_ID must be passed defined"
elif [[ -z "${AWS_SECRET_ACCESS_KEY}" ]] ; then
  echo "Error: AWS_SECRET_ACCESS_KEY must be passed defined"
elif [[ -z "${IAM_USER_NAME}" ]] ; then
  echo "Error: IAM_USER_NAME must be passed defined"
elif [[ -z "${MFA_OTP}" ]] ; then
  echo "Error: MFA OTP must be passed as first argument"
else
  MFA_SERIAL_NUMBER=$(
    aws iam list-virtual-mfa-devices | \
      jq \
        --arg iam_user_name "${IAM_USER_NAME}" \
        --raw-output '
            .VirtualMFADevices
          | map(select(.User.UserName == $iam_user_name))[0].SerialNumber
        '
  )

  STS_CREDS=$(
    aws sts get-session-token \
      --serial-number "${MFA_SERIAL_NUMBER}" \
      --token-code "${MFA_OTP}" | \
      jq --compact-output '.Credentials'
  )

  TOKEN_EXPIRATION=$(echo "${STS_CREDS}" | jq --raw-output '.Expiration')
  echo "Token expiration: ${TOKEN_EXPIRATION}"

  AWS_ACCESS_KEY_ID=$(echo "${STS_CREDS}" | jq --raw-output '.AccessKeyId')
  AWS_SECRET_ACCESS_KEY=$(echo "${STS_CREDS}" | jq --raw-output '.SecretAccessKey')
  AWS_SESSION_TOKEN=$(echo "${STS_CREDS}" | jq --raw-output '.SessionToken')

  export AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY
  export AWS_SESSION_TOKEN
fi
