#Resource ICD Database
resource "ibm_database" "postgresql" {
  name              = "${var.pfx}-${var.postgres_name}"
  plan              = "${var.postgres_plan}"
  location          = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  service           = "databases-for-postgresql"
  tags              = ["${var.tags}"]

  # adminpassword     = "password12"
  members_memory_allocation_mb = 3072
  members_disk_allocation_mb   = 61440
  # Create a user and password for the DB instance through variables passed by the user
  users = {
    name     = "${var.postgres_user}"
    password = "${var.postgres_user_pwd}"
  }

  timeouts {
    create = "90m"
    update = "3h"
    delete = "90m"
  }

  provisioner "local-exec" {
    # Create a database on the provisioned ICD Postgres instance
    command = <<EOT
    PGPASSWORD=${var.postgres_user_pwd} psql -h ${ibm_database.postgresql.connectionstrings.0.hosts.0.hostname} -p ${ibm_database.postgresql.connectionstrings.0.hosts.0.port} -U ${var.postgres_user} -d postgres -c "CREATE DATABASE ${var.postgres_db}"
    PGPASSWORD=${var.postgres_user_pwd} psql -h ${ibm_database.postgresql.connectionstrings.0.hosts.0.hostname} -p ${ibm_database.postgresql.connectionstrings.0.hosts.0.port} -U ${var.postgres_user} -d postgres -c "\l"
    EOT
  }
}

output "ICD-Postgres-DB-host" {
  value = "${ibm_database.postgresql.connectionstrings.0.hosts.0.hostname}"
}

output "ICD-Postgres-DB-port" {
  value = "${ibm_database.postgresql.connectionstrings.0.hosts.0.port}"
}
