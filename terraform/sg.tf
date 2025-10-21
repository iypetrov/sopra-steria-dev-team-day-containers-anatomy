resource "aws_security_group" "vm_sg" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_egress_rule" "vm_egress_rule" {
  security_group_id = aws_security_group.vm_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}
