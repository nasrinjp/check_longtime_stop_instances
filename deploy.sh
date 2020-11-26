#!/bin/bash

sam build --use-container

#sam package \
#    --output-template-file packaged.yaml \
#    --s3-bucket jsl-aws-sam-test

sam deploy \
    --stack-name cicd-test \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM
    --region us-west-2
