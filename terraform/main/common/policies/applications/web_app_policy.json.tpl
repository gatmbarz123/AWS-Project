{
  "Statement": [
    {
      "Sid": "ReadWriteS3",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:${PARTITION}:s3:::${SHORT_ENVIRONMENT}-${SHORT_REGION}-${BUCKET_NAME}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectTagging",
        "s3:GetObjectVersion",
        "s3:GetObjectVersionTagging",
        "s3:GetObjectACL",
        "s3:PutObjectACL"
      ],
      "Resource": [
        "arn:${PARTITION}:s3:::${SHORT_ENVIRONMENT}-${SHORT_REGION}-${BUCKET_NAME}/*"
      ]
    },
		{
			"Sid": "SESAccess",
			"Effect": "Allow",
			"Action": [
				"ses:*"
			],
			"Resource": "*"
		}  
  ],
  "Version": "2012-10-17"
}