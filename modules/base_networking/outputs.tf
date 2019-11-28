output "vpc_id" {
  description = "The ID of the created VPC."
  value       = "${aws_vpc.vpc.id}"
}

output "vpc_cidr" {
  description = "The CIDR of the created VPC."
  value       = "${aws_vpc.vpc.cidr_block}"
}

output "vpc_default_security_group_id" {
  description = "The CIDR of the created VPC."
  value       = "${aws_vpc.vpc.default_security_group_id}"
}

output "availability_zones" {
  description = "The availability zones in which subnets were created."
  value       = "${var.availability_zones}"
}

output "number_of_availability_zones" {
  description = "The number of populated availability zones available."
  value       = "${length(var.availability_zones)}"
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets."
  value       = ["${aws_subnet.public.*.id}"]
}

output "public_subnet_cidr_blocks" {
  description = "The CIDRs of the public subnets."
  value       = ["${aws_subnet.public.*.cidr_block}"]
}

output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = "${aws_route_table.public.id}"
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = ["${aws_subnet.private.*.id}"]
}

output "private_subnet_cidr_blocks" {
  description = "The CIDRs of the private subnets."
  value       = ["${aws_subnet.private.*.cidr_block}"]
}

output "private_route_table_id" {
  description = "The ID of the private route table."
  value       = "${aws_route_table.private.id}"
}

output "nat_public_ip" {
  description = "The EIP attached to the NAT."
  value       = "${aws_eip.nat.public_ip}"
}

output "dns_zone_id" {
  description = "ID of the private DNS zone attached to the VPC."
  value       = "${aws_route53_zone.private_zone.zone_id}"
}

output "resolver_inbound_dns_ips" {
  description = "IP for DNS inbound resolver"
  value       = "${aws_route53_resolver_endpoint.resolver_indbound_endpoint.ip_address}"
}
