#apache-security group
resource "aws_security_group" "apache" {
  name        = "apache"
  description = "this is using for securitygroup"
  vpc_id      = aws_vpc.stage-vpc.id

  ingress {
    description     = "this is inbound rule"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = ["${aws_security_group.grafana-sg.id}"]
  }
  ingress {
    description = "this is inbound rule"
    from_port   = 5044
    to_port     = 5044
    protocol    = "tcp"
    /* security_groups = ["${aws_security_group.ek-sg.id}"] */
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]

  }
  ingress {
    description     = "this is inbound rule"
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
    Name = "apache"
  }
}
#apacheuserdata
/* data "template_file" "apacheuser" {
  template = file("apache.sh")

} */
# apache instance
resource "aws_instance" "apache" {
  ami                    = var.ami_ubuntu
  instance_type          = var.type_ubuntu
  subnet_id              = aws_subnet.privatesubnet[1].id
  vpc_security_group_ids = [aws_security_group.apache.id]
  key_name               = aws_key_pair.deployer.id
  iam_instance_profile   = aws_iam_instance_profile.ssm_agent_instance_profile.name
  #user_data              = data.template_file.apacheuser.rendered
  user_data = file("scripts/apache.sh")
  tags = {
    Name = "stage-apache"
  }
}
