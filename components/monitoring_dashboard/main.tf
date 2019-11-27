terraform {
  backend "s3" {}
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 2.0"
}


data "terraform_remote_state" "training_kafka" {
  backend = "s3"
  config {
    key    = "training_kafka.tfstate"
    bucket = "tw-dataeng-${var.cohort}-tfstate"
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "training_emr_cluster" {
  backend = "s3"
  config {
    key    = "training_emr_cluster.tfstate"
    bucket = "tw-dataeng-${var.cohort}-tfstate"
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "ingester" {
  backend = "s3"
  config {
    key    = "ingester.tfstate"
    bucket = "tw-dataeng-${var.cohort}-tfstate"
    region = "${var.aws_region}"
  }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "2wheelers"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 12,
            "height": 3,
            "properties": {
                "metrics": [
                    [ "System/Linux", "MemoryUtilization", "InstanceId", "${data.terraform_remote_state.training_kafka.kafka_instance_id}", { "label": "MemoryUtilization" } ],
                    [ ".", "DiskSpaceUtilization", "MountPath", "/", "InstanceId", "${data.terraform_remote_state.training_kafka.kafka_instance_id}", "Filesystem", "/dev/xvda1" ]
                ],
                "view": "singleValue",
                "region": "${var.aws_region}",
                "title": "Kafka",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 3,
            "width": 12,
            "height": 9,
            "properties": {
                "metrics": [
                    [ "AWS/ElasticMapReduce", "HDFSUtilization", "JobFlowId", "${data.terraform_remote_state.training_emr_cluster.emr_cluster_id}" ],
                    [ ".", "AppsRunning", ".", "." ],
                    [ ".", "AppsPending", ".", "." ],
                    [ ".", "YARNMemoryAvailablePercentage", ".", "." ]
                ],
                "view": "singleValue",
                "stacked": false,
                "region": "${var.aws_region}",
                "period": 300,
                "title": "EMR HDFS"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 3,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "m2+m3", "label": "MemoryUsed", "id": "e1", "color": "#d62728" } ],
                    [ "AWS/ElasticMapReduce", "MemoryTotalMB", "JobFlowId", "${data.terraform_remote_state.training_emr_cluster.emr_cluster_id}", { "id": "m1", "color": "#1f77b4" } ],
                    [ ".", "MemoryReservedMB", ".", ".", { "id": "m2", "color": "#bcbd22" } ],
                    [ ".", "MemoryAllocatedMB", ".", ".", { "id": "m3", "color": "#ff7f0e" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.aws_region}",
                "period": 300,
                "title": "EMR Cluster Memory Usage"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 0,
            "width": 12,
            "height": 3,
            "properties": {
                "metrics": [
                    [ "System/Linux", "DiskSpaceUtilization", "MountPath", "/", "InstanceId", "${data.terraform_remote_state.training_kafka.kafka_instance_id}", "Filesystem", "/dev/xvda1", { "label": "DiskSpaceUtilization" } ],
                    [ ".", "MemoryUtilization", "InstanceId", "${data.terraform_remote_state.training_kafka.kafka_instance_id}" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.aws_region}",
                "title": "Kafka Status",
                "period": 300,
                "yAxis": {
                    "left": {
                        "max": 100,
                        "min": 0
                    }
                }
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 9,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/ElasticMapReduce", "AppsRunning", "JobFlowId", "${data.terraform_remote_state.training_emr_cluster.emr_cluster_id}" ],
                    [ ".", "AppsPending", ".", "." ],
                    [ ".", "ContainerReserved", ".", "." ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.aws_region}",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 9,
            "width": 12,
            "height": 3,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "System/Linux", "MemoryUtilization", "InstanceId", "${data.terraform_remote_state.ingester.ingester_instance_id}" ]
                ],
                "region": "${var.aws_region}",
                "title": "Ingester Memory Usage",
                "period": 300,
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 100
                    }
                }
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 15,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "2Wheelers_DeliveryFile", "file-exists", "Instance", "${data.terraform_remote_state.ingester.ingester_instance_id}" ],
                    [ ".", "file-updated", ".", "." ]
                ],
                "view": "singleValue",
                "title": "Delivery File",
                "region": "${var.aws_region}",
                "stat": "p99",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 15,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/Events", "TriggeredRules", "RuleName", "emr_step_failures", { "label": "EMR Step Failures" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "title": "EMR Step Failures",
                "region": "${var.aws_region}",
                "stat": "Sum",
                "period": 300,
                "start": "-PT3H",
                "end": "P0D"
            }
        }
    ]
}
 EOF
}
