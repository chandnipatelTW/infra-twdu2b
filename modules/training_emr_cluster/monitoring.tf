resource "aws_cloudwatch_event_rule" "step_failure" {
  name        = "emr_step_failures"
  description = "Failures During EMR Steps"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.emr"
  ],
  "detail-type": [
    "EMR Step Status Change"
  ],
  "detail": {
    "state": [
      "FAILED"
    ]
  }
}
PATTERN
}
resource "aws_cloudwatch_event_target" "failing_emr_step_target" {
  rule      = "${aws_cloudwatch_event_rule.step_failure.name}"
  arn       = "${aws_sns_topic.failing_emr_steps.arn}"
}

resource "aws_sns_topic" "failing_emr_steps" {
  name = "failing_emr_steps"
}

resource "aws_sns_topic_policy" "default" {
  arn    = "${aws_sns_topic.failing_emr_steps.arn}"
  policy = "${data.aws_iam_policy_document.sns_topic_policy.json}"
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = ["${aws_sns_topic.failing_emr_steps.arn}"]
  }
}