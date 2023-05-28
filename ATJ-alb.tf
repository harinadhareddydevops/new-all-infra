resource "aws_security_group" "alb-sg" {
  name        = "application-sg-lb"
  description = "this is using for securitygroup"
  vpc_id      = aws_vpc.stage-vpc.id

  ingress {
    description = "this is inbound rule"
    from_port   = 80
    to_port     = 80
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
    Name = "alb-sg"
  }
}

resource "aws_lb" "alb1" {
  name               = "atj-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = ["${aws_subnet.publicsubnet[0].id}", "${aws_subnet.publicsubnet[1].id}", "${aws_subnet.publicsubnet[2].id}"]
  tags = {
    Environment = "siva-alb"
  }
}


resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb1.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-jenkins.arn
  }
}


#apache
resource "aws_lb_target_group" "tg-apache" {
  name     = "tg-apache"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.stage-vpc.id
}
resource "aws_lb_target_group_attachment" "tg-attachment-apache" {
  target_group_arn = aws_lb_target_group.tg-apache.arn
  target_id        = aws_instance.apache.id
  port             = 80
}

resource "aws_lb_listener_rule" "apache-hostbased" {
  listener_arn = aws_lb_listener.alb-listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-apache.arn
  }
  condition {
    host_header {
      values = ["apache.sainath.quest"]
    }
  }
}

#jenlkins


# alb target-group
resource "aws_lb_target_group" "tg-jenkins" {
  name     = "tg-jenkins"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.stage-vpc.id
}

resource "aws_lb_target_group_attachment" "tg-attachment-jenkins" {
  target_group_arn = aws_lb_target_group.tg-jenkins.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}

# alb-listner_rule
resource "aws_lb_listener_rule" "jenkins-hostbased" {
  listener_arn = aws_lb_listener.alb-listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-jenkins.arn
  }

  condition {
    host_header {
      values = ["jenkins.sainath.quest"]
    }
  }
}

#tomcat



# alb target-group
resource "aws_lb_target_group" "tg-filebit" {
  name     = "tomcat-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.stage-vpc.id
}

resource "aws_lb_target_group_attachment" "tg-attachment-filebit" {
  target_group_arn = aws_lb_target_group.tg-filebit.arn
  target_id        = aws_instance.tomcat.id
  port             = 8080
}



# alb-listner_rule
resource "aws_lb_listener_rule" "filebit-hostbased" {
  listener_arn = aws_lb_listener.alb-listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-filebit.arn
  }

  condition {
    host_header {
      values = ["tomcat.sainath.quest"]
    }
  }
}

