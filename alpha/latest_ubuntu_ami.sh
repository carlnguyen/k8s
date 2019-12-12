#!/bin/bash

AMI='aws ec2 describe-images --owners 099720109477 --filters "Name=name,Values=ubuntu/images/hvm-instance/ubuntu-bionic-18.04-amd64-server-*" | jq '.Images[].Name' | head -n 1'
