# Generate new private key 
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}

# Generate a key-pair with above key
resource "aws_key_pair" "deployer" {
  key_name   = "mykey"
  public_key = tls_private_key.my_key.public_key_openssh
}

# Saving Key Pair
resource "local_file" "private_key" {
  content         = tls_private_key.my_key.private_key_pem
  filename        = "mykey.pem"
  file_permission = "0400"
}

#vpc
resource "aws_vpc" "this" {
  cidr_block = "10.100.0.0/16"
  tags = {
    Name = "upgrad-vpc"
  }
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.100.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "upgrad-public-1"
  }
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "upgrad-igw"
  }
}

#elastic ip
resource "aws_eip" "eip" {
  domain = "vpc"
}

#nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "upgrad-nat"
  }
}

#public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

#route table association
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

locals {
  instances = {
    instance1 = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
    }
    instance2 = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
    }
    instance3 = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
    }
  }
}

resource "aws_instance" "this" {
  for_each                    = local.instances
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  subnet_id                   = aws_subnet.public1.id
  security_groups             = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = each.key
  }

}

resource "local_file" "inventory" {
  content  = "[webservers]\n${join("\n", [for instance in aws_instance.this : instance.public_ip])}"
  filename = "inventory.ini"
}
