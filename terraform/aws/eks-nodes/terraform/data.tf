# Look up the EKS cluster
data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

# Look up private subnets for the cluster
data "aws_subnet" "selected" {
  for_each = toset(data.aws_eks_cluster.this.vpc_config[0].subnet_ids)
  id       = each.value
}

# Look up the existing IAM role
data "aws_iam_role" "eks_node_role" {
  name = "isaac-eks-node-role"
}