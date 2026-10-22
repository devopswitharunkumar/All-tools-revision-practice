resource "aws_instance" "local" {
    ami = data.aws_ami.id_fetch.id
    instance_type = var.instance_type
    tags = {
        name = local.instance_name              #locals.instance_name   is wrong
    }

    provisioner "local-exec" {
      command = "echo EC2 started"
    }

    provisioner "local-exec" {
      command = "echo [prac] > inventory"
    }

    provisioner "local-exec" {
      command = "echo ${self.public_ip} >> inventory"
    }
    # provisioner "local-exec" {
    #   command = "rm -rf inventory"
    # }

    provisioner "local-exec" {
      command = "sudo dnf install ansible -y"
    }

    provisioner "local-exec" {
      command = "ansible-playbook -i inventory -e ansible_user=ec2-user -e ansible_password=DevOps321 nginx.yaml"
    }
}