output "node_group_names" {
  value       = keys(aws_eks_node_group.this)
  description = "The names of all EKS node groups created in this Terraform run."
}

output "node_group_arns" {
  value       = { for k, v in aws_eks_node_group.this : k => v.arn }
  description = "The ARN (Amazon Resource Name) for each EKS node group, keyed by node group name."
}

output "node_group_statuses" {
  value       = { for k, v in aws_eks_node_group.this : k => v.status }
  description = "The current provisioning status of each EKS node group (e.g., ACTIVE, CREATING, UPDATING)."
}

output "node_group_role_arns" {
  value       = { for k, v in aws_eks_node_group.this : k => v.node_role_arn }
  description = "The IAM role ARN associated with each node group."
}

output "node_group_instance_types" {
  value       = { for k, v in aws_eks_node_group.this : k => v.instance_types }
  description = "The EC2 instance types used by each node group."
}

output "node_group_subnets" {
  value       = { for k, v in aws_eks_node_group.this : k => v.subnet_ids }
  description = "The subnet IDs each node group is deployed into."
}

output "node_group_scaling" {
  value = {
    for k, v in aws_eks_node_group.this : k => {
      min_size     = v.scaling_config[0].min_size
      desired_size = v.scaling_config[0].desired_size
      max_size     = v.scaling_config[0].max_size
    }
  }
  description = "Scaling configuration (min, desired, max) for each node group."
}

output "node_group_labels" {
  value       = { for k, v in aws_eks_node_group.this : k => v.labels }
  description = "The Kubernetes labels assigned to each node group."
}

output "node_group_taints" {
  value       = { for k, v in var.node_groups : k => v.taints }
  description = "The Kubernetes taints assigned to each node group (from TFVars)."
}
