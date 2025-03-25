provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "rke_master" {
  ami           = "ami-0f9de6e2d2f067fca" # Amazon Linux 2 AMI
  instance_type = "t2.medium"
  key_name = aws_key_pair.deployer.key_name
 
  tags = {
    Name = "RKE-Master"
  }
}

resource "aws_instance" "rke_worker" {
  count         = 2
  ami           = "ami-0f9de6e2d2f067fca"
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