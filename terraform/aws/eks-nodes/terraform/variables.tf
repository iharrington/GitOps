variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-1"
}

variable "product_name" {
  description = "Product name for Backstage"
  type        = string
  default     = "EKS"
}

variable "environment" {
  description = "Environment for Backstage"
  type        = string
  default     = "prod"
}

variable "cluster_name" {
  description = "Name of the existing EKS cluster to attach node groups to"
  type        = string
}

variable "node_groups" {
  description = <<EOT
Map of node group configurations.
Example:
{
  app-nodes = {
    instance_type = "t3.medium"
    capacity_type = "ON_DEMAND" # or "SPOT"
    desired_size  = 2
    min_size      = 1
    max_size      = 4
    disk_size     = 20
    labels        = { role = "app" }
    taints = [
      {
        key    = "dedicated"
        value  = "app"
        effect = "NO_SCHEDULE"
      }
    ]
  }
}
EOT
  type = map(object({
    instance_type = string
    capacity_type = string
    desired_size  = number
    min_size      = number
    max_size      = number
    disk_size     = number
    ami_type      = string
    labels        = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string # NO_SCHEDULE, PREFER_NO_SCHEDULE, NO_EXECUTE
    }))
  }))
}
