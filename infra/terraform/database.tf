variable "db_password" {}
variable "db_username" {}

resource "aws_db_instance" "example_db" {
  identifier_prefix          = "redmine-"
  allocated_storage          = "20"
  engine                     = "postgres"
  instance_class             = "db.t2.medium"
  name                       = "redmine"
  username                   = var.db_username
  password                   = var.db_password
  engine_version             = "11.6"
  vpc_security_group_ids     = [ aws_eks_cluster.example.vpc_config.0.cluster_security_group_id ]

  tags = {
    Project = "Redmine"
  }
}

output "db-address" {
  value = aws_db_instance.example_db.address
}