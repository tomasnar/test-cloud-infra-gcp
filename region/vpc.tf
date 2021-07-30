resource "aws_vpc" "main" {
  cidr_block = cidrsubnet(var.base_cidr_block, 4, 1)
  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name_prefix}-igw"
  }
}
