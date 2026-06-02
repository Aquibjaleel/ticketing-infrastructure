variable "vpc_id" {}
variable "public_subnet_ids" {}

# The Load Balancer Core
resource "aws_lb" "app_gateway" {
  name               = "agw-dev"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  tags               = { Environment = "dev" }
}

# The WAF Firewall Core (Replicating WAF_v2 "Detection" mode)
resource "aws_wafv2_web_acl" "agw_waf" {
  name        = "agw-waf-dev"
  description = "WAF for Application Gateway"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "agwWafMetric"
    sampled_requests_enabled   = true
  }
}

# Associated the Firewall directly to the Gateway
resource "aws_wafv2_web_acl_association" "waf_assoc" {
  resource_arn = aws_lb.app_gateway.arn
  web_acl_arn  = aws_wafv2_web_acl.agw_waf.arn
}