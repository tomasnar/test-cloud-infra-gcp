resource "aws_security_group" "region" {
  name        = "${var.name_prefix}-region"
  description = "Open access within this region"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
}
