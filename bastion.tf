# bastion - security group
resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "this is using for securitygroup"
  vpc_id      = aws_vpc.stage-vpc.id

  ingress {
    description = "this is inbound rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bastion"
  }
}
# bastion instance
resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = var.type
  subnet_id              = aws_subnet.publicsubnet[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = aws_key_pair.deployer.id
  tags = {
    Name = "stage-bastion"
  }
}