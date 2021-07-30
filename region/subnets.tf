data "aws_availability_zones" "all" {}

module "subnet1" {
  source            = "./subnet"
  vpc_id            = aws_vpc.main.id
  igw_id            = aws_internet_gateway.main.id
  availability_zone = data.aws_availability_zones.all.names[0]
}

module "subnet2" {
  source            = "./subnet"
  vpc_id            = aws_vpc.main.id
  igw_id            = aws_internet_gateway.main.id
  availability_zone = data.aws_availability_zones.all.names[1]
}

module "subnet3" {
  source            = "./subnet"
  vpc_id            = aws_vpc.main.id
  igw_id            = aws_internet_gateway.main.id
  availability_zone = data.aws_availability_zones.all.names[2]
}
