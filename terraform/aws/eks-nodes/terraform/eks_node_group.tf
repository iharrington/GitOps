# EKS Node Groups
resource "aws_eks_node_group" "this" {
  for_each = var.node_groups

  cluster_name    = var.cluster_name
  node_group_name = each.key
  node_role_arn   = data.aws_iam_role.eks_node_role.arn
  subnet_ids      = [for s in data.aws_subnet.selected : s.id]
  capacity_type   = each.value.capacity_type

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  ami_type       = each.value.ami_type
  instance_types = [each.value.instance_type]
  disk_size      = each.value.disk_size
  labels         = each.value.labels

  # Optional taints support
  dynamic "taint" {
    for_each = each.value.taints
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [data.aws_eks_cluster.this]
}
