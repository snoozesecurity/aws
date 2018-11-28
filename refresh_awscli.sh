#!/bin/bash

# Enroll your AWS account to use virtual MFA; I used Google Authenticator due to ease of setup.
# NOTE: This script MUST be run in the current shell context, as such: . ./refresh_awscli.sh

# Gets rid of stale environment variables if they exist

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

echo "Enter current MFA token: "
read userToken

# Provide the ARN of your MFA device in the following json variable declaration:

json=$(aws sts get-session-token --serial-number arn:aws:iam::001122334455/username --token-code $userToken)

# Assigns variables using the above json output from the awscli command

awsKeyId=$(echo $json | jq -r '.Credentials' | jq --raw-output '.AccessKeyId')
awsSecretKey=$(echo $json | jq -r '.Credentials' | jq --raw-output '.SecretAccessKey')
awsToken=$(echo $json | jq -r '.Credentials' | jq --raw-output '.SessionToken')

# Sets environment variables using the above

export AWS_ACCESS_KEY_ID="$awsKeyId"
export AWS_SECRET_ACCESS_KEY="$awsSecretKey"
export AWS_SESSION_TOKEN="$awsToken"

echo "Done!"
