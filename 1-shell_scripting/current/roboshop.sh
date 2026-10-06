#!/bin/bash 

ID=$(id -u)

ami_id=ami-0220d79f3f480ecf5
sg_id=sg-0356688fc6f675992
Domain_name=devopswitharun.online
ZONE_ID=Z02149386QBAC23T25TA

Instances=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "cart" "user" "shipping" "payment" "web")

for i in "${Instances[@]}"
do  
    echo "Instance is : $i"
    if [ $i == "mongodb" ] || [ $i == "shipping" ] || [ $i == "mysql" ]
    then 
        instance_type="t3.medium"
    else
        instance_type="t2.micro"
    fi

    ip_address=$(aws ec2 run-instances --region us-east-1 --image-id $ami_id --instance-type $instance_type --security-group-ids $sg_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
    echo "$i : $ip_address"

    # Creates route 53 records based on env name

    aws route53 change-resource-record-sets \
    --hosted-zone-id "$ZONE_ID" \
    --change-batch '
    {
        "Comment": "Creating an A record for my web server",
        "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
            "Name": "'$i'.'$Domain_name'",
            "Type": "A",
            "TTL": 1,
            "ResourceRecords": [
                {
                "Value": "'$ip_address'"
                }
            ]
            }
        }
        ]
    }'

done 

