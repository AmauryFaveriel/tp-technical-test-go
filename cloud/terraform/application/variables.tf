variable "instance_type" {
  type = string
  default = "t2.micro"
  description = "Instance type"
}

variable "instance_ami" {
  type = string
  description = "Instance AMI"
}

variable "instance_count" {
  type = number
  default = 1
  description = "Number of instances"
}

variable "instance_key_name" {
  type = string
  description = "Key name for SSH access"
}

variable "stage" {
  type = string
  description = "Stage which application is deployed"
}

variable "cluster_instance_type" {
  type = string
  default = "cache.t2.micro"
  description = "Elasticache cluster instance type"
}

variable "cluster_num_cache" {
  type = number
  default = 1
  description = "Number of cluster elasticache"
}