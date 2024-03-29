resource "aws_instance" "airflow" {
  # FIXME: Use a specialised airflow AMI
  ami                    = "${data.aws_ami.amazon_linux_2.image_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.airflow.id}"]
  subnet_id              = "${var.subnet_ids[0]}"
  key_name               = "${var.ec2_key_pair}"
  iam_instance_profile   = "${aws_iam_instance_profile.airflow.name}"

  user_data = <<EOF
          #! /bin/bash
          set -x

          export LC_CTYPE=en_US.UTF-8
          export AIRFLOW_HOME=/usr/local/airflow

          sudo amazon-linux-extras install -y epel

          sudo yum update -y

          sudo yum install -y python-pip
          sudo yum install -y gcc gcc-c++
          sudo pip install apache-airflow
          sudo pip install apache-airflow[crypto]
          sudo pip install apache-airflow[postgres,jdbc]

          sudo chown -R ec2-user: /usr/local/airflow

          airflow initdb

          nohup airflow webserver -p 8080 -D
          nohup airflow scheduler -D

  EOF

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "airflow-${var.deployment_identifier}"
    )
  )}"

  # TODO: Remove this once we have dedicated airflow AMI
  lifecycle {
    ignore_changes = ["ami"]
  }
}

