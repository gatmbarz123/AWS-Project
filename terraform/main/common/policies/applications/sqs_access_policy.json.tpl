{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SQSAllow",
            "Effect": "Allow",
            "Action": [
                "sqs:DeleteMessage",
                "sqs:ListQueues",
                "sqs:GetQueueUrl",
                "sqs:ListDeadLetterSourceQueues",
                "sqs:ChangeMessageVisibility",
                "sqs:ListMessageMoveTasks",
                "sqs:ReceiveMessage",
                "sqs:GetQueueAttributes",
                "sqs:ListQueueTags"
            ],
            "Resource": "*"
        }
    ]
}