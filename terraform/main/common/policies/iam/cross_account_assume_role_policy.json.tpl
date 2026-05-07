{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": [
        "arn:${PARTITION}:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
      ]
    }
  ]
}