resource "aws_security_group" "rds_sg" {
  name        = local.sg_name
  vpc_id      = local.vpc_id

  ingress {
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # -1 significa todos os protocolos
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.sg_name}"
  }
}
