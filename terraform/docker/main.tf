terraform {
resource "docker_volume" "pg_data" {
name = "devops_pg_data"
}


resource "docker_image" "app_image" {
name = "devops_mtf_app:latest"
build {
context = "${path.root}/../../"
dockerfile = "${path.root}/../../Dockerfile"
}
}


resource "docker_container" "postgres" {
name = "devops_postgres"
image = "postgres:13"
networks_advanced {
name = docker_network.app_net.name
}
env = [
"POSTGRES_USER=${var.pg_user}",
"POSTGRES_PASSWORD=${var.pg_password}",
"POSTGRES_DB=${var.pg_database}"
]
volumes {
volume_name = docker_volume.pg_data.name
container_path = "/var/lib/postgresql/data"
}
ports {
internal = 5432
external = 5432
}
}


resource "docker_container" "api" {
name = "devops_api"
image = docker_image.app_image.name
networks_advanced {
name = docker_network.app_net.name
}
env = [
"DB_HOST=${docker_container.postgres.name}",
"DB_PORT=5432",
"DB_USER=${var.pg_user}",
"DB_PASSWORD=${var.pg_password}",
"DB_DATABASE=${var.pg_database}",
"PORT=3000"
]
ports {
internal = 3000
external = var.api_port
}
depends_on = [docker_container.postgres]
}