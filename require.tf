terraform {
  required_version = ">= 0.11.0"
}

provider "libvirt" {
  version = "~> 0.5.1"
}

provider "random" {
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.0"
}

provider "tls" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}
