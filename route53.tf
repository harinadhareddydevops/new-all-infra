#r53.tf

data "aws_route53_zone" "route53" {
  name         = "sainath.quest"
  private_zone = false
}

resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "jenkins.${data.aws_route53_zone.route53.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb1.dns_name
    zone_id                = aws_lb.alb1.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "nexus" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "nexus.${data.aws_route53_zone.route53.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb1.dns_name
    zone_id                = aws_lb.alb1.zone_id
    evaluate_target_health = true
  }
} 
resource "aws_route53_record" "kibana" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "kibana.${data.aws_route53_zone.route53.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb2.dns_name
    zone_id                = aws_lb.alb2.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "prometheus" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "prometheus.${data.aws_route53_zone.route53.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb2.dns_name
    zone_id                = aws_lb.alb2.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "apache" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "apache.${data.aws_route53_zone.route53.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb1.dns_name
    zone_id                = aws_lb.alb1.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "sonarqube" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "sonarqube.${data.aws_route53_zone.route53.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb1.dns_name
    zone_id                = aws_lb.alb1.zone_id
    evaluate_target_health = true
  }
} 

resource "aws_route53_record" "tomcat" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "tomcat.${data.aws_route53_zone.route53.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb1.dns_name
    zone_id                = aws_lb.alb1.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "grafana.${data.aws_route53_zone.route53.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb2.dns_name
    zone_id                = aws_lb.alb2.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "frontend.${data.aws_route53_zone.route53.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb3.dns_name
    zone_id                = aws_lb.alb3.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = "backend.${data.aws_route53_zone.route53.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb4.dns_name
    zone_id                = aws_lb.alb4.zone_id
    evaluate_target_health = true
  }
}



