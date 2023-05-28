resource "aws_security_group" "frontend-sg" {
  name        = "frontend-sg"
  description = "securitygroup for frontend"
  vpc_id      = aws_vpc.stage-vpc.id

  ingress {
    description     = "allow ssh from bastion"
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
  ingress {
    description     = "allow 3000 from loadbalancer"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "frontend-sg"
  }
}
# frontend instance
resource "aws_instance" "frontend" {
  ami                    = var.ami
  instance_type          = var.type
  subnet_id              = aws_subnet.privatesubnet[1].id
  vpc_security_group_ids = [aws_security_group.frontend-sg.id]
  key_name               = aws_key_pair.deployer.id
  #user_data              = data.template_file.grafanauser.rendered
  iam_instance_profile = aws_iam_instance_profile.ssm_agent_instance_profile.name
  tags = {
    Name = "frontend"
  }
}