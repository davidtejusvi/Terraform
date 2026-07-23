resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr


  enable_dns_support = true

  enable_dns_hostnames = true


  tags = {

    Name = "terraform-vpc"

  }

}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id


  tags = {

    Name = "terraform-igw"

  }

}

resource "aws_subnet" "public" {

  for_each = var.public_subnets

  vpc_id = aws_vpc.main.id

  cidr_block = each.value

  availability_zone = var.availability_zones[each.key]

  map_public_ip_on_launch = true

  tags = {

    Name = each.key

  }
}


resource "aws_subnet" "private" {

  for_each = var.private_subnets


  vpc_id = aws_vpc.main.id


  cidr_block = each.value


  availability_zone = var.availability_zones[each.key]


  map_public_ip_on_launch = false


  tags = {

    Name = each.key

  }

}

resource "aws_subnet" "db" {

  for_each = var.db_subnets


  vpc_id = aws_vpc.main.id


  cidr_block = each.value


  availability_zone = var.availability_zones[each.key]


  map_public_ip_on_launch = false


  tags = {

    Name = each.key

  }

}




resource "aws_route_table" "public" {


  vpc_id = aws_vpc.main.id


  route {


    cidr_block = "0.0.0.0/0"


    gateway_id = aws_internet_gateway.igw.id

  }


  tags = {

    Name = "public-route-table"

  }

}

resource "aws_route_table_association" "public" {

  for_each = aws_subnet.public


  subnet_id = each.value.id


  route_table_id = aws_route_table.public.id


}

resource "aws_security_group" "web" {


  name = "allow-web"


  description = "Allow SSH and HTTP"


  vpc_id = aws_vpc.main.id



  ingress {


    from_port = 22


    to_port = 22


    protocol = "tcp"


    cidr_blocks = ["0.0.0.0/0"]

  }



  ingress {


    from_port = 80


    to_port = 80


    protocol = "tcp"


    cidr_blocks = ["0.0.0.0/0"]

  }



  egress {


    from_port = 0


    to_port = 0


    protocol = "-1"


    cidr_blocks = ["0.0.0.0/0"]

  }


  tags = {

    Name = "web-security-group"

  }

}

resource "aws_instance" "web" {

  ami = var.ami_id

  instance_type = var.instance_type


  subnet_id = aws_subnet.public["tf-public-subnet-1a"].id


  vpc_security_group_ids = [
    aws_security_group.web.id
  ]


  user_data = <<-EOF
              #!/bin/bash

              dnf update -y

              dnf install httpd -y

              systemctl start httpd

              systemctl enable httpd


              echo "<html>
              <body>
              <h1>Hello from Terraform EC2</h1>
              <p>This webpage was deployed using AWS User Data</p>
              </body>
              </html>" > /var/www/html/index.html

              EOF


  tags = {

    Name = "terraform-web-server"

  }

}





