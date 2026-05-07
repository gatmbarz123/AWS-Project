{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Principal": {
              "Federated": "arn:${PARTITION}:iam::${ACCOUNT_ID}:oidc-provider/${EKS_OIDC_PROVIDER}"
          },
          "Action": "sts:AssumeRoleWithWebIdentity",
          "Condition": {
              "StringEquals": {
                  "${EKS_OIDC_PROVIDER}:aud": "sts.amazonaws.com",
                  "${EKS_OIDC_PROVIDER}:sub": "${SERVICEACCOUNT_PATH}"
              }
          }
      }
  ]
}