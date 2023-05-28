resource "aws_security_group" "backend-alb-sg" {
  name        = "backend-sg-lb"
  description = "this is using for securitygroup"
  vpc_id      = aws_vpc.stage-vpc.id

  ingress {
    description     = "this is inbound rule"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.frontend-sg.id}"]
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
resource "aws_lb" "alb4" {
    name               = "backend-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb-sg.id]
    subnets            = ["${aws_subnet.publicsubnet[0].id}", "${aws_subnet.publicsubnet[1].id}", "${aws_subnet.publicsubnet[2].id}"]
    tags = {
      Environment = "backend-alb"
    }
 }
resource "aws_lb_listener" "backend-listener" {
  load_balancer_arn = aws_lb.alb4.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend-tg.arn
  }
}

#frontend
resource "aws_lb_target_group" "backend-tg" {
  name     = "backend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.stage-vpc.id
}
resource "aws_lb_target_group_attachment" "backend-attachment" {
  target_group_arn = aws_lb_target_group.backend-tg.arn
  target_id        = aws_instance.backend.id
  port             = 80
}

resource "aws_lb_listener_rule" "backend-hostbased" {
  listener_arn = aws_lb_listener.backend-listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend-tg.arn
  }

  condition {
    host_header {
      values = ["backend.sainath.quest"]
    }
  }
}