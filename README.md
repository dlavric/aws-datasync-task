# aws-datasync-task
This is a test repository that is creating an AWS resource DataSync Task with the required policies

## Pre-requisites

- [X] [Terraform](https://www.terraform.io/downloads)
- [X] [AWS Account](https://aws.amazon.com/resources/create-account/)

## Steps on how to use this repository

- Clone this repository:
```shell
git clone https://github.com/dlavric/aws-datasync-task.git
```

- Go to the directory where the repo is stored:
```shell
cd aws-datasync-task
```


- Export your AWS Keys on your terminal
```shell
export AWS_REGION="eu-west-1"
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...                  
```

- Initialize Terraform to download the providers and the modules
```shell
terraform init
```

- Apply the changes
```shell
terraform apply
```

- Comment the `schedule` block from the `main.tf` file

- Apply the changes again
```shell
terraform apply
```

- See the output
```shell
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_datasync_task.example will be updated in-place
  ~ resource "aws_datasync_task" "example" {
        id                       = "arn:aws:datasync:eu-west-1:<account-id>:task/task-0dc2155d059cb16c9"
        name                     = "daniela-datasync-task2"
        tags                     = {}
        # (4 unchanged attributes hidden)

      - schedule {
          - schedule_expression = "cron(0/60 * * * ? *)" -> null
        }

        # (1 unchanged block hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

- When finished, destroy your test
```shell
terraform destroy
```
