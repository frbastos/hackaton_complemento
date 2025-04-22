resource "postgresql_database" "videodb" {
  name = "videodb"
  owner = "postgres"
}