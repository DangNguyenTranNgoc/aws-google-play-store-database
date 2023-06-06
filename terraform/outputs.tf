# output "foo" {
#   value = var.aws_access_key
#   sensitive = true
# }

# output "bar" {
#   value = var.aws_serect_key
#   sensitive = true
# }

# output "web_server_ip" {
#   description = "The public ip of the web server"
#   value = aws_eip.web_eip.public_ip
#   depends_on = [ aws_eip.web_eip ]
# }

# output "db_endpoint" {
#   description = "The enpoint of the database"
#   value = aws_db_instance.lab_db.address
#   depends_on = [ aws_db_instance.lab_db ]
# }
