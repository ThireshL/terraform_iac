resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = "billing-alarm-over-1-dollar"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600" # 6 hours
  statistic           = "Maximum"
  threshold           = "1" # Threshold in USD
  alarm_description   = "Alarm when AWS charges exceed $1"

  dimensions = {
    Currency = "USD"
  }
}