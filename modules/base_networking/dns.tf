resource "aws_route53_zone" "private_zone" {
  name = "${var.private_dns_zone_name}"
  vpc {
    vpc_id = "${aws_vpc.vpc.id}"
  }
  tags = "${local.common_tags}"
}

resource "aws_route53_zone" "private_zone_dev" {
  name = "${var.private_dns_zone_name}_dev"
  vpc {
    vpc_id = "${aws_vpc.vpc.id}"
  }
  tags = "${local.common_tags}"
}
