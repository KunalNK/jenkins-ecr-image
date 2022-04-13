#!/bin/bash
ecs-cli configure --cluster ec2-tutorial --default-launch-type EC2 \
--config-name ec2-tutorial --region ap-south-1

ecs-cli configure profile --access-key $AWS_ACCESS_KEY_ID \
--secret-key $AWS_SECRET_ACCESS_KEY \
--profile-name ec2-tutorial-profile

ecs-cli up --keypair kk-ec2 --capability-iam --size 2 --instance-type t2.micro \
--cluster-config ec2-tutorial --ecs-profile ec2-tutorial-profile --port 5000

sleep 60

ecs-cli compose up --create-log-groups --cluster-config ec2-tutorial \
--ecs-profile ec2-tutorial-profile

ecs-cli ps --cluster-config ec2-tutorial --ecs-profile ec2-tutorial-profile