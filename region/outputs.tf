output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet1_id" {
  value = module.subnet1.subnet_id
}

output "subnet2_id" {
  value = module.subnet2.subnet_id
}

output "subnet3_id" {
  value = module.subnet3.subnet_id
}
