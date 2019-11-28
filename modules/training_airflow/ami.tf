data "aws_ami" "training_airflow" {
	most_recent = true
	owners      = ["self"]

	filter {
		name   = "name"
		values = ["data-eng-airflow-training-*"]
	}
}
