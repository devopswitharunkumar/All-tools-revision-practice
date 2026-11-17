resource "aws_instance" "remote" {
    ami = data.aws_ami.ami_id_fetch.id 
    instance_type = var.instance_type
    vpc_security_group_ids = [ aws_security_group.security.id ]

    tags = var.tags

    provisioner "local-exec" {
      command = "echo [prac] > inventory.ini"
    }
    provisioner "local-exec" {
      command = "echo ${self.public_ip} >> inventory.ini"
    }
    provisioner "local-exec" {
      command = "echo [prac:vars] >> inventory.ini"
    }
    provisioner "local-exec" {
      command = "echo ansible_user=ec2-user >> inventory.ini"
    }
    provisioner "local-exec" {
      command = "echo ansible_password=DevOps321 >> inventory.ini"
    }

    connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      password = "DevOps321"
    }

    provisioner "file" {
      source = "inventory.ini"
      destination = "/home/ec2-user/inventory.ini"
    }

    provisioner "file" {
      source = "nginx.yaml"
      destination = "/home/ec2-user/nginx.yaml"
    }

    provisioner "remote-exec" {
      inline = [
        "sudo dnf install ansible -y",
        "ansible-playbook -i inventory.ini /home/ec2-user/nginx.yaml"
      ] 
    }

    provisioner "local-exec" {
        when = destroy
      command = "echo destory instance"
    }

}

resource "aws_security_group" "security" {
    name = var.sg_name
    description = var.description

    ingress {
        description = "Allow inbound traffic"
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow outbound traffic"
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}