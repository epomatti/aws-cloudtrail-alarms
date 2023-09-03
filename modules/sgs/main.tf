resource "aws_security_group" "cloudtrail" {
  name        = "cloudtrail-test-sg"
  description = "Testing with CloudTrail"
  vpc_id      = var.vpc_id

  tags = {
    Name = "cloudtrail-test-sg"
  }
}

resource "aws_security_group_rule" "allow_all_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cloudtrail.id
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cloudtrail.id
}
