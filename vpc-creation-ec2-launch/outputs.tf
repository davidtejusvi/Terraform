output "instance_public_ip" {

  value = aws_instance.web.public_ip

}


output "website_url" {

  value = "http://${aws_instance.web.public_ip}"

}


output "vpc_id" {

  value = aws_vpc.main.id

}


output "public_subnet_ids" {

  value = {
    for subnet_name, subnet in aws_subnet.public :
    subnet_name => subnet.id
  }

}


output "private_subnet_ids" {

  value = {
    for subnet_name, subnet in aws_subnet.private :
    subnet_name => subnet.id
  }


}


output "db_subnet_ids" {

  value = {
    for subnet_name, subnet in aws_subnet.db :
    subnet_name => subnet.id
  }

}

