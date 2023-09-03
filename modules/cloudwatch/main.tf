### Security Groups

resource "aws_cloudwatch_log_metric_filter" "security_groups" {
  name           = "SecurityGroupEvents"
  pattern        = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup) }"
  log_group_name = var.cloudtrail_cloudwatch_group_name

  metric_transformation {
    name      = "SecurityGroupEventCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "sg_event_count" {
  # Metric
  namespace   = aws_cloudwatch_log_metric_filter.security_groups.metric_transformation[0].namespace
  metric_name = aws_cloudwatch_log_metric_filter.security_groups.metric_transformation[0].name
  statistic   = "Sum"
  period      = 300

  # Conditions
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  threshold                 = 1
  evaluation_periods        = 1
  insufficient_data_actions = []

  # Notification
  alarm_actions = [aws_sns_topic.sg_changes.arn]

  # Name and description
  alarm_name        = "SecurityGroupEventCount"
  alarm_description = "This metric monitors ec2 cpu utilization"
}

resource "aws_sns_topic" "sg_changes" {
  name = "SecurityGroupChanges_CloudWatch_Alarms_Topic"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.sg_changes.arn
  protocol  = "email"
  endpoint  = var.sns_topic_subscription_email
}

### Authentication Failures ###

# resource "aws_cloudwatch_log_metric_filter" "auth_failures" {
#   name           = "AuthorizationFailures"
#   pattern        = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"
#   log_group_name = var.cloudtrail_cloudwatch_group_name

#   metric_transformation {
#     name      = "AuthorizationFailureCount"
#     namespace = "CloudTrailMetrics"
#     value     = "1"
#   }
# }
