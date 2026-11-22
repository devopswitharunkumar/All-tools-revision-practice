
#!/bin/bash
set -e

component=$1
environment=$2          #env_name value will be attached to this variable because in $2 we gave ${var.env_name} in main.tf either prod or dev
app_version=$3
packaging=$4

dnf install -y python3 python3-pip python3-boto3 python3-botocore git ansible
cd /home/ec2-user/

# Install RabbitMQ Ansible collection only for rabbitmq component
if [ "$component" == "rabbitmq" ]
then
    echo "Environment is : $environment"
    echo "Installing RabbitMQ Ansible collection..."
    ansible-galaxy collection install community.rabbitmq
else
    echo "RabbitMQ collection not required for $component"
    echo "Environment is : $environment"
fi

###########we are implememting pull based architecture for databases########


ansible-pull -U https://github.com/devopswitharunkumar/All-tools-revision-practice.git \
  -i "9-roboshop-terraform-infra-dev/roboshop-ansible-using-roles-tf/${environment}/inventory.ini" \
  -e "component=$component" \
  -e "env=$environment" \
  -e "app_version=$app_version" \
  -e "packaging=$packaging" \
  9-roboshop-terraform-infra-dev/roboshop-ansible-using-roles-tf/main-tf.yaml




# REPO_URL="https://github.com/devopswitharunkumar/All-tools-revision-practice.git"
# REPO_DIR="/home/ec2-user/ansible-pull"
# PROJECT_DIR="9-roboshop-terraform-infra-dev/roboshop-ansible-using-roles-tf"

# ansible-pull \
#     -U "$REPO_URL" \
#     -d "$REPO_DIR" \
#     -i "$REPO_DIR/$PROJECT_DIR/${environment}/inventory.ini" \
#     -e "component=$component" \
#     -e "env=$environment" \
#     -e "app_version=$app_version" \
#     "$REPO_DIR/$PROJECT_DIR/main-tf.yaml"

# -U: Git repository URL.
# -d: Local repository checkout directory.
# -i: Inventory file.
# -e: Extra variables.
# Last argument: Playbook to execute.