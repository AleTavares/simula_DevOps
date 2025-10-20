terraform {
most_recent = true
owners = ["099720109477"] # Canonical
filter {
name = "name"
values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
}
}


resource "aws_instance" "app" {
ami = data.aws_ami.ubuntu.id
instance_type = var.instance_type
key_name = var.key_name
vpc_security_group_ids = [aws_security_group.sg_app.id]


user_data = <<-EOF
#!/bin/bash
apt-get update -y
apt-get install -y curl git build-essential
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
apt-get install -y postgresql-client


cd /home/ubuntu
git clone https://github.com/MayODay11/DevOps_MTF.git app || exit 1
cd app
npm ci


cat > .env <<EOL
DB_HOST=${aws_db_instance.rds.address}
DB_PORT=5432
DB_USER=${var.db_username}
DB_PASSWORD=${var.db_password}
DB_DATABASE=devops_class
PORT=3000
EOL


nohup npm start > app.log 2>&1 &
EOF


tags = {
Name = "devops-mtf-app"
}
}


resource "aws_db_instance" "rds" {
allocated_storage = 20
engine = "postgres"
engine_version = "13"
instance_class = "db.t3.micro"
name = "devops_class"
username = var.db_username
password = var.db_password
skip_final_snapshot = true
publicly_accessible = true
vpc_security_group_ids = [aws_security_group.sg_app.id]
}