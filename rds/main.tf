resource "aws_db_subnet_group" "mysql" {
  name = "mysql-subnet-group"

  subnet_ids = [
    # db-subnet-private-1a
    "subnet-0632150bdc3258fab",
    # db-subnet-private-1b   
    "subnet-05161b1729a93592f"
  ]
}

resource "aws_db_instance" "mysql" {
  identifier        = var.db_identifier
  engine            = var.db_engine
  engine_version    = var.db_version
  instance_class    = var.db_instance
  allocated_storage = var.db_storage
  storage_type      = var.db_storage_type
  db_name           = var.db_mysql_name
  username          = var.db_username
  password          = var.db_password

  db_subnet_group_name = aws_db_subnet_group.mysql.name
  publicly_accessible  = false
  # Automated Backup (snapshot)
  backup_retention_period = var.db_backup_retention_period

  # Termination protection
  deletion_protection = var.db_deletion_protection

  vpc_security_group_ids = ["sg-0fb6557c30a115360"]

  skip_final_snapshot       = false
  final_snapshot_identifier = "my-mysql-db-final-snapshot"

  apply_immediately = true

  tags = {
    Name = "my-mysql-db"
  }


}
