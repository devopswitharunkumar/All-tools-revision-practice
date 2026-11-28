resource "aws_instance" "docker" {
  ami = data.aws_ami.redhat-9-ami-id.id
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.allow_docker.id ]

  user_data = templatefile("${path.module}/docker-installation.sh.tftpl", {
        partition_number = 4
        extend_size = 30
  })

  root_block_device {
        volume_size           = 50      # Size of the volume in GiB
        volume_type           = "gp3"   # General Purpose SSD (gp3 is recommended)
        tags = {
            Name = "docker"
            Project = "roboshop"
            Environment = "dev"
        }
    }

  tags = {
    Name= "docker"      #Name must be same then only u can see the instance name in AWS console
    environment = "dev"
    project = "roboshop"
  }
}



# It creates in default VPC
resource "aws_security_group" "allow_docker" {
  name        = "allow_terraform"
  description = "Allow TLS inbound traffic and all outbound traffic"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      =  ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port        = 80
  #   to_port          = 80
  #   protocol         = "tcp"
  #   cidr_blocks      =  ["0.0.0.0/0"]
  # }

  # ingress {
  #   from_port        = 8080
  #   to_port          = 8080
  #   protocol         = "tcp"
  #   cidr_blocks      =  ["0.0.0.0/0"]
  # }

#for practice concepts 
    ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # all traffic
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  # outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # all traffic
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-docker"
    Project = "roboshop"
    Environment = "dev"
  }
}