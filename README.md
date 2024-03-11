# Setup

1. Create an S3 bucket `rebelinblue-terraform-state` in `eu-west-2` 

* Enable encryption
* Enable bucket versioning
* Block public access

2. Create a DynamoDB table `terraform-state-lock` in `eu-west-2` with a Partition key `LockID` of type `string`

3. Create an IAM user with an attached policy and create an access key

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
				"dynamodb:DescribeTable",
				"dynamodb:GetItem",
				"dynamodb:PutItem",
				"dynamodb:DeleteItem"
			],
			"Resource": "arn:aws:dynamodb:eu-west-2:338122837542:table/terraform-state-lock"
		}
	]
}
```