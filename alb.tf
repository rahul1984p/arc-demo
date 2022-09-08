module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "7.0.0"

  name = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id = aws_default_vpc.default.id
  security_groups = [aws_security_group.alb-sg.id]
  # Listeners
    http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
    
  ]  

  
  # Target Groups
  target_groups = [
    # App1 Target Group
    {
      name_prefix      = "app1-"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }      

    }     
  ]
  tags = local.common_tags # ALB Tags
}