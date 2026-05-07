data "aws_partition" "current" {}

resource "aws_sqs_queue" "sqs" {
  count                     = var.create_sqs ? 1 : 0
  name                      = "${var.name}-upload-events"
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}

resource "aws_sqs_queue_policy" "allow_s3" {
  count = var.create_sqs ? 1 : 0

  queue_url = aws_sqs_queue.sqs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:${data.aws_partition.current.partition}:iam::${var.aws_account_id}:root"
        }
        Action   = "SQS:*"
        Resource = aws_sqs_queue.sqs[0].arn
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SQS:SendMessage"
        Resource = aws_sqs_queue.sqs[0].arn
        Condition = {
          "ArnLike" = {
            "aws:SourceArn" : aws_s3_bucket.s3.arn
          },
          "StringEquals" = {
            "aws:SourceAccount" : var.aws_account_id
          }
        }
      }
    ]
  })
}