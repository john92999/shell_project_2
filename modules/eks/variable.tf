variable "vpc_id"             { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "cluster_name"       { type = string }
variable "cluster_version"    { default = "1.32"}
variable "node_instance_type" { type = string }