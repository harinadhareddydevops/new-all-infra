resource "aws_security_group" "siva-rds-sg" {
  name        = "alb-sg"
  description = "this is using for securitygroup"
  vpc_id      = aws_vpc.stage-vpc.id

  ingress {
    description     = "this is inbound rule"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.apache.id}"]

  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.tomcat.id}"]

  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jenkins.id}"]

  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]

  }
 ingress {
    description     = "this is inbound rule"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.frontend-sg.id}"]

  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.backend-sg.id}"]

  }

}
resource "aws_db_subnet_group" "db-subnetgroup" {
  name = "db-subnetgroup"
  # subnet_ids = [module.vpc.aws_subnet.datasubnet[0].id, module.vpcaws_subnet.datasubnet[1].id, module.vpcaws_subnet.datasubnet[2].id]
  #subnet_ids = [var.datasubnet1, var.datasubnet2, var.datasubnet3] 
  subnet_ids = [aws_subnet.datasubnet[0].id, aws_subnet.datasubnet[1].id, aws_subnet.datasubnet[2].id]
  tags = {
    Name = "rdssubnet-group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = "mydb"
  username               = "sivadev"
  password               = "sriram2662"
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.db-subnetgroup.name
  vpc_security_group_ids = ["${aws_security_group.siva-rds-sg.id}"]
  skip_final_snapshot    = true
  tags = {
    "name" = "stage-rds"
  }
}


