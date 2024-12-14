#!/bin/bash

# Set variables
KEY_NAME="my-key-pair" # Change this to your desired key pair name
SECURITY_GROUP_NAME="my-security-group"
INSTANCE_TYPE="t2.micro"
AMI_ID="ami-0dba2cb6798deb6d8" # Replace with the latest Ubuntu AMI ID for your region
REGION="us-east-1" # Change to your desired AWS region

# Step 1: Create a key pair and save the private key
if [ ! -f "$KEY_NAME.pem" ]; then
  echo "Creating a new key pair..."
  aws ec2 create-key-pair \
    --key-name "$KEY_NAME" \
    --query "KeyMaterial" \
    --output text > "$KEY_NAME.pem"
  chmod 400 "$KEY_NAME.pem"
else
  echo "Key pair already exists. Skipping creation."
fi

# Step 2: Create a security group
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
  --group-name "$SECURITY_GROUP_NAME" \
  --description "Security group for EC2 instance" \
  --query 'GroupId' \
  --output text)

# Add rules to allow SSH, HTTP, and HTTPS traffic
aws ec2 authorize-security-group-ingress \
  --group-id "$SECURITY_GROUP_ID" \
  --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress \
  --group-id "$SECURITY_GROUP_ID" \
  --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress \
  --group-id "$SECURITY_GROUP_ID" \
  --protocol tcp --port 443 --cidr 0.0.0.0/0

# Step 3: Launch the EC2 instance
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --count 1 \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --query 'Instances[0].InstanceId' \
  --output text)

# Wait until the instance is running
echo "Waiting for the instance to be in 'running' state..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

# Get the public IP address of the instance
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "Instance launched successfully!"
echo "Instance ID: $INSTANCE_ID"
echo "Public IP: $PUBLIC_IP"

# Step 4: Connect to the instance via SSH
echo "Connecting to the instance via SSH..."
ssh -i "$KEY_NAME.pem" ubuntu@$PUBLIC_IP
