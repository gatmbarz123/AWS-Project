{
    "Statement": [
        {
            "Action": [
                "ec2:AttachVolume",
                "ec2:ExportImage",
                "ec2:DescribeInstances",
                "ec2:DeleteTags",
                "ec2:CreateKeyPair",
                "ec2:DescribeRegions",
                "ec2:CreateImage",
                "ec2:DescribeSnapshots",
                "ec2:DeleteVolume",
                "ec2:DescribeVolumeStatus",
                "ec2:DescribeVolumes",
                "ec2:CreateSnapshot",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeInstanceStatus",
                "ec2:DetachVolume",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeTags",
                "ec2:CreateTags",
                "ec2:RunInstances",
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:DescribeVolumeAttribute",
                "ec2:DescribeSecurityGroups",
                "ec2:CreateVolume",
                "ec2:DescribeImages",
                "ec2:CreateLaunchTemplate",
                "ec2:DescribeSecurityGroupRules",
                "ec2:DescribeInstanceTypes",
                "iam:ListRoles",
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "iam:ListInstanceProfiles"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ],
            "Sid": "EC2Access"
        },
        {
            "Action": [
                "ecr:DescribeImages",
                "ecr:ListImages",
                "ecr:BatchGetImage",
                "ecr:GetAuthorizationToken"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ecr:eu-central-1:123456789012:repository/python-ai-base",
                "arn:aws:ecr:eu-central-1:123456789012:repository/python-ai-research",
                "arn:aws:ecr:eu-central-1:123456789012:repository/python-ai"
            ],
            "Sid": "ECRaccess"
        },
        {
            "Sid": "AllowPassLMAlgoMachinesRole",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::123456789012:role/example-algo-machines"
        },
        {
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectAttributes",
                "s3:ListBucket",
                "s3:GetObjectVersion",
                "s3:ListBucketVersions"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::example-algo",
                "arn:aws:s3:::example-algo/*",
                "arn:aws:s3:::play-euc1-example-test-data",
                "arn:aws:s3:::play-euc1-example-test-data/*",
                "arn:aws:s3:::play-euc1-example-algo",
                "arn:aws:s3:::play-euc1-example-algo/*",
                "arn:aws:s3:::local-hub-devs",
                "arn:aws:s3:::local-hub-devs/*",
                "arn:aws:s3:::example-hub-playground",
                "arn:aws:s3:::example-hub-playground/*"
            ],
            "Sid": "S3RWAccess"
        },
        {
            "Action": "s3:DeleteObject",
            "Effect": "Deny",
            "NotResource": [
                "arn:aws:s3:::play-euc1-example-algo/clearml/.clearml.*.test"
            ],
            "Sid": "S3DenyDeleteExceptPermissionTest"
        },
        {
            "Sid": "AllowDeletePermissionsTest",
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::play-euc1-example-algo/clearml/.clearml.*.test"
        }
    ],
    "Version": "2012-10-17"
}