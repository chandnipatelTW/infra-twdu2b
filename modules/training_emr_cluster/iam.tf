resource "aws_iam_role" "emr_service" {
  name = "emr-service-${var.deployment_identifier}"

  # TODO: Replace this with data resource
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticmapreduce.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "emr_service_managed" {
  name = "emr-service-managed-${var.deployment_identifier}"
  roles = ["${aws_iam_role.emr_service.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

resource "aws_iam_instance_profile" "emr_node" {
  name = "emr-node-${var.deployment_identifier}"
  role = "${aws_iam_role.emr_node.name}"
}

resource "aws_iam_role" "emr_node" {

  name = "emr-node-${var.deployment_identifier}"

  # TODO: Replace this with data resource
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "emr_node_managed" {
  name       = "emr-node-managed-${var.deployment_identifier}"
  roles      = ["${aws_iam_role.emr_node.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

