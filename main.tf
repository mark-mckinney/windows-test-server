provider "aws" {
    region = "us-east-2"
    access_key = var.access_key
    secret_key = var.private_key
}

resource "aws_instance" "windows-test-server" {
    ami = "ami-019a4607ba39bfde6"
    instance_type = "t2.micro"
    availability_zone = "us-east-2a"
    vpc_security_group_ids = [ aws_security_group.win_allow_ssh.id] 
    key_name = var.ssh_key_name

    associate_public_ip_address = true
    get_password_data = true

    tags = {
        "Name" = "Windows-Test-Server"
    }
}

resource "aws_security_group" "win_allow_ssh" {
  name = "win_allow_ssh"
  description = "Win Allow SSH"

  ingress {
      description = "ssh"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
      description = "rdp"
      from_port = 3389
      to_port = 3389
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      "Name" = "Win_Allow_SSH"
  }
}



output "public_ip" {
  value = aws_instance.windows-test-server.public_ip
}

output "public_dns" {
  value = aws_instance.windows-test-server.public_dns
}

output "password_decrypted" { 
    value = rsadecrypt(aws_instance.windows-test-server.password_data, file("key/aws-main-access-key.pem"))
}

output "user_name" {
  value = "Administrator"
}


