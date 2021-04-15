terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {}

resource "aws_instance" "instance" {
  count         = 1
  ami           = "ami-06098fd00463352b6"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    "sg-05e257e5f67735da5",
  ]
  subnet_id = "subnet-ee0c39a8"
  key_name = "r-goto"
  tags = {
    Owner = "r-goto"
    Name = format("chef-demo-node-web%02d", count.index + 1)
    Project = "chef-demo"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname AWS-web-node`date +%d%S`",
      "sudo dnf -y install wget",
      "sudo wget -O /tmp/chef.rpm  https://packages.chef.io/files/stable/chef/16.13.16/el/8/chef-16.13.16-1.el7.x86_64.rpm",
      "sudo rpm -Uvh /tmp/chef.rpm",
      "sudo chef-client -z --chef-license accept",
      "sudo chmod 777 /etc/chef"
    ]
    connection {
      host = self.public_ip
      user = "ec2-user"
      type = "ssh"
      private_key = file("/home/r-goto/r-goto_aws.pem")
    }
  }

  provisioner "file" {
    source      = ".chef/"
    destination = "/etc/chef"

    connection {
      host = self.public_ip
      user = "ec2-user"
      type = "ssh"
      private_key = file("/home/r-goto/r-goto_aws.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo knife ssl fetch",
      "sudo chef-client"
    ]
    connection {
      host = self.public_ip
      user = "ec2-user"
      type = "ssh"
      private_key = file("/home/r-goto/r-goto_aws.pem")
    }
  }
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.instance.*.public_ip
}
