{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowArgoCDClusterAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:${PARTITION}:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}