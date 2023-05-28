#backend-sg-security group
resource "aws_security_group" "backend-sg" {
  name        = "backend-sg"
  description = "securitygroup for backend"
  vpc_id      = aws_vpc.stage-vpc.id

  ingress {
    description     = "allow 80 from alb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.backend-alb-sg.id}"]
  }
  ingress {
    description     = "allow 22 from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }
  ingress {
    description     = "allow ssh from jenkins"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jenkins.id}"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "backend-sg"
  }
}
# apache instance
resource "aws_instance" "backend" {
  ami                    = var.ami
  instance_type          = var.type
  subnet_id              = aws_subnet.privatesubnet[1].id
  vpc_security_group_ids = [aws_security_group.backend-sg.id]
  key_name               = aws_key_pair.deployer.id
  #user_data              = data.template_file.grafanauser.rendered
  iam_instance_profile = aws_iam_instance_profile.ssm_agent_instance_profile.name
  tags = {
    Name = "backend"
  }
}