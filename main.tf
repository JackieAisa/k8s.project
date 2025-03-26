provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "rke_master" {
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t2.medium"
  key_name = aws_key_pair.deployer.key_name
 
  tags = {
    Name = "RKE-Master"
  }
}

resource "aws_instance" "rke_worker" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t2.medium"
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "RKE-Worker-${count.index}"
  }
}

output "rke_master_ip" {
  value = aws_instance.rke_master.public_ip
}

output "rke_worker_ips" {
  value = aws_instance.rke_worker[*].public_ip
}