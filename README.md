# Setup

1. Create an S3 bucket `rebelinblue-terraform-state` in `eu-west-2` 

* Enable encryption
* Enable bucket versioning
* Block public access

2. Create an IAM user with an attached policy and create an access key

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "s3:ListBucket",
			"Resource": "arn:aws:s3:::rebelinblue-terraform-state"
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:GetObject",
				"s3:PutObject"
			],
			"Resource": "arn:aws:s3:::rebelinblue-terraform-state/*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:DeleteObject"
			],
			"Resource": "arn:aws:s3:::rebelinblue-terraform-state/*.tflock"
		}
	]
}
```