{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:${PARTITION}:s3:::${S3_BUCKET_NAME}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": ${CLOUD_TRAIL_ARNS}
        }
      }
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": ${S3_BUCKET_KEY_PREFIXES},
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control",
          "AWS:SourceArn": ${CLOUD_TRAIL_ARNS}
        }
      }
    }
  ]
}