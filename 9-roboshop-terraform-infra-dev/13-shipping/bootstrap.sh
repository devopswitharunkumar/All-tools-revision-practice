
#!/bin/bash
set -e

component=$1
environment=$2

dnf install -y python3 python3-pip python3-boto3 python3-botocore git ansible
cd /home/ec2-user/

# Install RabbitMQ Ansible collection only for rabbitmq component
if [ "$component" == "rabbitmq" ]
then
    echo "Installing RabbitMQ Ansible collection..."
    ansible-galaxy collection install community.rabbitmq
else
    echo "RabbitMQ collection not required for $component"
fi

###########we are implememting pull based architecture for databases########


ansible-pull -U https://github.com/devopswitharunkumar/All-tools-revision-practice.git \
  -i "9-roboshop-terraform-infra-dev/roboshop-ansible-using-roles-tf/${environment}/inventory.ini" \
  -e component=$component \
  -e env=$environment \
  9-roboshop-terraform-infra-dev/roboshop-ansible-using-roles-tf/main-tf.yaml
