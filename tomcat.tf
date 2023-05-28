#security_group
resource "aws_security_group" "tomcat" {
  name        = "tomcat-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.stage-vpc.id

  ingress {
    description = "admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks = ["45.249.77.103/32"]
    security_groups = ["${aws_security_group.jenkins.id}"]
  }
  ingress {
    description     = "admin"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  ingress {
    description = "admin"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "admin"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "admin"
    from_port   = 5044
    to_port     = 5044
    protocol    = "tcp"
    /* security_groups = ["${aws_security_group.ek-sg.id}"] */
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "admin"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
    /* cidr_blocks = ["0.0.0.0/0"] */
  }
  ingress {
    description     = "admin"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
    /* cidr_blocks = ["0.0.0.0/0"] */
  }
  ingress {
    description     = "admin"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = ["${aws_security_group.grafana-sg.id}"]
    /* cidr_blocks = ["0.0.0.0/0"] */
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Tomcat-sg"
  }
}
/* data "template_file" "filebituser" {
  template = file("fb-user-data.sh")

} */
#instance
resource "aws_instance" "tomcat" {
  ami           = var.ami_ubuntu
  instance_type = var.type_ubuntu
  subnet_id     = aws_subnet.privatesubnet[0].id
  # availability_zone = data.aws_availability_zones.available.names[0]
  key_name               = aws_key_pair.deployer.id
  vpc_security_group_ids = [aws_security_group.tomcat.id]
  #user_data              = data.template_file.filebituser.rendered
  iam_instance_profile = aws_iam_instance_profile.ssm_agent_instance_profile.name
  user_data            = file("scripts/tomcat.sh")
  tags = {
    Name = "tomcat"
  }
}

