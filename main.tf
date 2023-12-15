terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# iam role
resource "aws_iam_role" "role" {
  name = "daniela-datasync-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "datasync.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# role policy
resource "aws_iam_policy" "s3policy" {
  name = "daniela-datasync-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListStorageLensConfigurations",
          "s3:ListAccessPointsForObjectLambda",
          "s3:GetAccessPoint",
          "s3:PutAccountPublicAccessBlock",
          "s3:GetAccountPublicAccessBlock",
          "s3:ListAllMyBuckets",
          "s3:ListAccessPoints",
          "s3:PutAccessPointPublicAccessBlock",
          "s3:ListJobs",
          "s3:PutStorageLensConfiguration",
          "s3:ListMultiRegionAccessPoints",
          "s3:CreateJob"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : "*"
      }
    ]
  })
}

# attach policy to role
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.s3policy.arn
}


resource "aws_s3_bucket" "bucket" {
  bucket = "daniela-datasync-bucket2"
}

resource "aws_s3_object" "source" {
  bucket = aws_s3_bucket.bucket.id
  key    = "source/"
}

resource "aws_s3_object" "destination" {
  bucket = aws_s3_bucket.bucket.id
  key    = "destination/"
}


resource "aws_datasync_location_s3" "s3destination" {
  s3_bucket_arn = aws_s3_bucket.bucket.arn
  subdirectory  = "/destination/"

  s3_config {
    bucket_access_role_arn = aws_iam_role.role.arn
  }
}

resource "aws_datasync_location_s3" "s3source" {
  s3_bucket_arn = aws_s3_bucket.bucket.arn
  subdirectory  = "/source/"

  s3_config {
    bucket_access_role_arn = aws_iam_role.role.arn
  }
}

resource "aws_datasync_task" "example" {
  destination_location_arn = aws_datasync_location_s3.s3destination.arn
  name                     = "daniela-datasync-task2"
  source_location_arn      = aws_datasync_location_s3.s3source.arn

#   schedule {
#     schedule_expression = "cron(0/60 * * * ? *)"
#   }

  options {
    posix_permissions = "NONE"
    verify_mode       = "ONLY_FILES_TRANSFERRED"
    gid               = "NONE"
    uid               = "NONE"
  }
}
