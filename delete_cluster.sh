#!/bin/bash
ecs-cli down --force --cluster-config ec2-tutorial --ecs-profile ec2-tutorial-profile

aws ecr delete-repository \
    --repository-name image_name \
    --force
