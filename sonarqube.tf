#apache-security group
resource "aws_security_group" "sonar" {
  name        = "sonar-sg"
  description = "this is using for securitygroup"
  vpc_id      = aws_vpc.stage-vpc.id

  ingress {
    description = "this is inbound rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jenkins.id}"]

  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
    /* cidr_blocks = ["0.0.0.0/0"] */
  }

  ingress {
    description = "this is inbound rule"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = ["${aws_security_group.grafana-sg.id}"]
    /* cidr_blocks = ["0.0.0.0/0"] */
  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 5044
    to_port         = 5044
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ek-sg.id}"]
  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sonar"
  }
}
# apache instance
resource "aws_instance" "sonar" {
  ami                    = var.ami_ubuntu
  instance_type          = var.type_ubuntu
  subnet_id              = aws_subnet.privatesubnet[1].id
  vpc_security_group_ids = [aws_security_group.sonar.id]
  key_name               = aws_key_pair.deployer.id
  iam_instance_profile   = aws_iam_instance_profile.ssm_agent_instance_profile.name
  #user_data              = data.template_file.apacheuser.rendered
  user_data = file("scripts/sonar.sh")
  tags = {
    Name = "stage-sonar"
  }
}



# alb target-group
resource "aws_lb_target_group" "tg-sonar" {
  name     = "tg-sonar"
  port     = 9000
  protocol = "HTTP"
  vpc_id   = aws_vpc.stage-vpc.id
}

resource "aws_lb_target_group_attachment" "tg-attachment-sonar" {
  target_group_arn = aws_lb_target_group.tg-sonar.arn
  target_id        = aws_instance.sonar.id
  port             = 9000
}



# alb-listner_rule
resource "aws_lb_listener_rule" "sonar-hostbased" {
  listener_arn = aws_lb_listener.alb-listener.arn
  #   priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-sonar.arn
  }

  condition {
    host_header {
      values = ["sonarqube.sainath.quest"]
    }
  }
}

