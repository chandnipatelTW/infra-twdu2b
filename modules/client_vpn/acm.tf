data "aws_acm_certificate" "root" {
  domain      = "${var.cohort}${var.env}.training"
  types       = ["IMPORTED"]
  most_recent = true
}

data "aws_acm_certificate" "server" {
  domain      = "openvpn.${var.cohort}${var.env}.training"
  types       = ["IMPORTED"]
  most_recent = true
}
