
# Add DNS entry
resource "aws_route53_record" "app" {
  name = var.domain
  type = "CNAME"

  records = [
    var.alb_dns_name,
  ]

  zone_id = var.dns_zone_id
  ttl     = "60"
}
