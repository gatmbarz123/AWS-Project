resource "aws_s3_bucket_notification" "bucket_notification" {
  # Create notifications when either SQS rules or EventBridge integration is enabled.
  count = (length(var.sqs_notifications) > 0 || var.enable_eventbridge) ? 1 : 0

  bucket      = aws_s3_bucket.s3.id
  eventbridge = var.enable_eventbridge

  dynamic "queue" {
    for_each = var.sqs_notifications
    content {
      queue_arn     = aws_sqs_queue.sqs[0].arn
      events        = queue.value.events
      filter_prefix = queue.value.filter_prefix
      filter_suffix = queue.value.filter_suffix
    }
  }

  depends_on = [aws_sqs_queue_policy.allow_s3]
}
