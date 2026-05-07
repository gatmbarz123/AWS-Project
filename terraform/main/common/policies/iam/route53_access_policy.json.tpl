{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:GetHostedZone",
        "route53:ListTagsForResource"
      ],
      "Resource": [
        "arn:${PARTITION}:route53:::hostedzone/${HOSTED_ZONE_ID}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    },
    {
			"Effect": "Allow",
			"Action": "route53:GetChange",
			"Resource": "arn:${PARTITION}:route53:::change/*"
		}
  ]
}