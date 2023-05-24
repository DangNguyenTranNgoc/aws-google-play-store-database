# aws-google-play-store-database

Building a database to store data from Google Play Store on AWS RDS with Terraform

## Protect Sensitive Input Variables

Steps:

1. Write credential data to a `.tfvars` like `secret.tfvars`

```
db_username = "admin"
db_password = "insecurepassword"
```

2. Define variables to store sensitive data
```
variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}
```

3. Use variables
```
resource "aws_db_instance" "database" {
  allocated_storage = 5
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  username          = var.db_username
  password          = var.db_password

  db_subnet_group_name = aws_db_subnet_group.private.name
  skip_final_snapshot = true
}
```

4. Attach secret file `secret.tfvars` when run apply

```
terraform apply -var-file="secret.tfvars"
```

Or we can use enviroment variables!!!
