resource "aws_cloudwatch_metric_alarm" "file_does_not_exist" {
  alarm_name                = "file-does-not-exist-alarm"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "file-exists"
  namespace                 = "2Wheelers_DeliveryFile"
  period                    = "300"
  extended_statistic        = "p99"
  threshold                 = "1"
  alarm_description         = "Monitors the existance of a delivery file"
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "file_not_updated" {
  alarm_name                = "file-not-updated-alarm"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "file-updated"
  namespace                 = "2Wheelers_DeliveryFile"
  period                    = "300"
  extended_statistic        = "p99"
  threshold                 = "1"
  alarm_description         = "Monitors the delivery file having been updated"
  insufficient_data_actions = []
}
