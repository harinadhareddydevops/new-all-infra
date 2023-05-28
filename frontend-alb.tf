resource "aws_lb" "alb3" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = ["${aws_subnet.publicsubnet[0].id}", "${aws_subnet.publicsubnet[1].id}", "${aws_subnet.publicsubnet[2].id}"]
  tags = {
    Environment = "frontend-alb"
  }
}


resource "aws_lb_listener" "frontend-listener" {
  load_balancer_arn = aws_lb.alb3.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-tg.arn
  }
}

#frontend
resource "aws_lb_target_group" "frontend-tg" {
  name     = "frontend-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.stage-vpc.id
}
resource "aws_lb_target_group_attachment" "frontend-attachment" {
  target_group_arn = aws_lb_target_group.frontend-tg.arn
  target_id        = aws_instance.frontend.id
  port             = 3000
}

resource "aws_lb_listener_rule" "frontend-hostbased" {
  listener_arn = aws_lb_listener.frontend-listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-tg.arn
  }

  condition {
    host_header {
      values = ["frontend.sainath.quest"]
    }
  }
}