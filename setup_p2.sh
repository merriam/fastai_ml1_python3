#!/usr/bin/env bash

AMI_FASTAI_PYTHON_2_7=
export vpcId=`aws ec2 create-vpc --cidr-block 10.0.0.0/28 --query 'Vpc.VpcId' --output text`
aws ec2 modify-vpc-attribute --vpc-id $vpcId --enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute --vpc-id $vpcId --enable-dns-hostnames "{\"Value\":true}"
export internetGatewayId=`aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text`
aws ec2 attach-internet-gateway --internet-gateway-id $internetGatewayId --vpc-id $vpcId
export subnetId=`aws ec2 create-subnet --vpc-id $vpcId --cidr-block 10.0.0.0/28 --query 'Subnet.SubnetId' --output text`
export routeTableId=`aws ec2 create-route-table --vpc-id $vpcId --query 'RouteTable.RouteTableId' --output text`
aws ec2 associate-route-table --route-table-id $routeTableId --subnet-id $subnetId
aws ec2 create-route --route-table-id $routeTableId --destination-cidr-block 0.0.0.0/0 --gateway-id $internetGatewayId
export securityGroupId=`aws ec2 create-security-group --group-name my-security-group --description "Generated by setup_vpn.sh" --vpc-id $vpcId --query 'GroupId' --output text`
aws ec2 authorize-security-group-ingress --group-id $securityGroupId --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $securityGroupId --protocol tcp --port 8888-8898 --cidr 0.0.0.0/0
aws ec2 create-key-pair --key-name aws-key --query 'KeyMaterial' --output text > ~/.ssh/aws-key.pem
chmod 400 ~/.ssh/aws-key.pem

export instanceId=`aws ec2 run-instances --image-id ami-bc508adc --count 1 --instance-type p2.xlarge --key-name aws-key --security-group-ids $securityGroupId --subnet-id $subnetId --associate-public-ip-address --block-device-mapping "[ { \"DeviceName\": \"/dev/sda1\", \"Ebs\": { \"VolumeSize\": 128, \"VolumeType\": \"gp2\" } } ]" --query 'Instances[0].InstanceId' --output text`
export allocAddr=`aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text`

echo Waiting for instance start...
aws ec2 wait instance-running --instance-ids $instanceId
sleep 10 # wait for ssh service to start running too
export assocId=`aws ec2 associate-address --instance-id $instanceId --allocation-id $allocAddr --query 'AssociationId' --output text`
export instanceUrl=`aws ec2 describe-instances --instance-ids $instanceId --query 'Reservations[0].Instances[0].PublicDnsName' --output text`
echo securityGroupId=$securityGroupId
echo subnetId=$subnetId
echo instanceId=$instanceId
echo instanceUrl=$instanceUrl
echo Connect: ssh -i ~/.ssh/aws-key.pem ubuntu@$instanceUrl

