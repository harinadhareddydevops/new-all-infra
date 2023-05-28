resource "aws_lb" "alb2" {
  name               = "gpk-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = ["${aws_subnet.publicsubnet[0].id}", "${aws_subnet.publicsubnet[1].id}", "${aws_subnet.publicsubnet[2].id}"]

  tags = {
    Environment = "alb-gpk"
  }
}

resource "aws_lb_listener" "gpk-alb-listener" {
  load_balancer_arn = aws_lb.alb2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-grafana.arn
  }
}

#grafana
resource "aws_lb_target_group" "tg-grafana" {
  name     = "grafana"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.stage-vpc.id
}

resource "aws_lb_target_group_attachment" "tg-attachment-grafana" {
  target_group_arn = aws_lb_target_group.tg-grafana.arn
  target_id        = aws_instance.Grafana.id
  port             = 3000
}

resource "aws_lb_listener_rule" "grafana-hostbased" {
  listener_arn = aws_lb_listener.gpk-alb-listener.arn
  #   priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-grafana.arn
  }

  condition {
    host_header {
      values = ["grafana.sainath.quest"]
    }
  }
}

#prometheus
resource "aws_lb_target_group" "tg-prometheus" {
  name     = "prometheus"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = aws_vpc.stage-vpc.id
}

resource "aws_lb_target_group_attachment" "tg-attachment-prometheus" {
  target_group_arn = aws_lb_target_group.tg-prometheus.arn
  target_id        = aws_instance.Grafana.id
  port             = 9090
}

resource "aws_lb_listener_rule" "prometheus-hostbased" {
  listener_arn = aws_lb_listener.gpk-alb-listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-prometheus.arn
  }

  condition {
    host_header {
      values = ["prometheus.sainath.quest"]
    }
  }
}

#kibana
resource "aws_lb_target_group" "tg-kibana" {
  name     = "kibana-target"
  port     = 5601
  protocol = "HTTP"
  vpc_id   = aws_vpc.stage-vpc.id
}

resource "aws_lb_target_group_attachment" "tg-attachment-kibana" {
  target_group_arn = aws_lb_target_group.tg-kibana.arn
  target_id        = aws_instance.elasticsearch-kibana.id
  port             = 5601
}

resource "aws_lb_listener_rule" "kibana-hostbased" {
  listener_arn = aws_lb_listener.gpk-alb-listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-kibana.arn
  }

  condition {
    host_header {
      values = ["kibana.sainath.quest"]
    }
  }
} 