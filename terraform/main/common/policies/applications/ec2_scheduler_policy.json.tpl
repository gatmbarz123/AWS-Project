{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EC2SchedulerDescribeReadOnly",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    },
    {
      "Sid": "EC2SchedulerSpecificInstancesActions",
      "Effect": "Allow",
      "Action": [
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:CreateTags",
        "ec2:DeleteTags"
      ],
      "Resource": [
        "arn:aws:ec2:eu-central-1:123456789012:instance/i-02d6e1b688f2184ec",
        "arn:aws:ec2:eu-central-1:123456789012:instance/i-062d5b6f81eca93e1",
        "arn:aws:ec2:eu-central-1:123456789012:instance/i-08ab1d14e48dd17ab",
        "arn:aws:ec2:eu-central-1:123456789012:instance/i-004c3b19ce98483a6",
        "arn:aws:ec2:eu-central-1:123456789012:instance/i-01bcbd79f57b55b36",
        "arn:aws:ec2:eu-central-1:123456789012:instance/i-0b6e4acb5075b0278"
      ]
    }
  ]
}
