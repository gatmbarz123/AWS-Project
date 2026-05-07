{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSConfigBucketPermissionsCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:${PARTITION}:s3:::${S3_BUCKET_NAME}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceAccount": ${ORGANIZATION_ACCOUNT_IDS}
        }
      }
    },
    {
      "Sid": "AWSConfigBucketExistenceCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "s3:ListBucket",
      "Resource": "arn:${PARTITION}:s3:::${S3_BUCKET_NAME}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceAccount": ${ORGANIZATION_ACCOUNT_IDS}
        }
      }
    },
    {
      "Sid": "AWSConfigBucketDelivery",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:${PARTITION}:s3:::${S3_BUCKET_NAME}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control",
          "AWS:SourceAccount": ${ORGANIZATION_ACCOUNT_IDS}
        }
      }
    }
  ]
}