{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GetBucketLocation",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:${PARTITION}:s3:::${SHORT_ENVIRONMENT}-${SHORT_REGION}-example-projects*"
        },
        {
            "Sid": "ListAllMyBuckets",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
        {
            "Sid": "ObjectOperations",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:${PARTITION}:s3:::${SHORT_ENVIRONMENT}-${SHORT_REGION}-example-projects*/*"
        }
    ]
}
