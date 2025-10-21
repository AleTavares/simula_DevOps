terraform {
 required_version = ">= 1.0.0"
 backend "local" {
    path = "terraform.tfstate"
  } 
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
}