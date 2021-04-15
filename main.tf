terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-3"
}

resource "aws_instance" "instance" {
  count         = 1
  ami           = "ami-0b96303a469fa0678"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    "sg-0803dfbfc0c77a2f4",
  ]
  subnet_id = "subnet-130aaf5e"
  key_name = "r-goto-osaka"
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
      private_key = file("/home/r-goto/r-goto_aws-osaka.pem")
    }
  }

  provisioner "file" {
    source      = ".chef/"
    destination = "/etc/chef"

    connection {
      host = self.public_ip
      user = "ec2-user"
      type = "ssh"
      private_key = file("/home/r-goto/r-goto_aws-osaka.pem")
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
