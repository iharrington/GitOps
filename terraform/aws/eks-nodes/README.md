# eks-nodes

Terraform repo to create EKS Node Groups

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_role.existing_node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the existing EKS cluster to attach node groups to | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for Backstage | `string` | `"prod"` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Map of node group configurations.<br>Example:<br>{<br>  app-nodes = {<br>    instance\_type = "t3.medium"<br>    capacity\_type = "ON\_DEMAND" # or "SPOT"<br>    desired\_size  = 2<br>    min\_size      = 1<br>    max\_size      = 4<br>    disk\_size     = 20<br>    labels        = { role = "app" }<br>    taints = [<br>      {<br>        key    = "dedicated"<br>        value  = "app"<br>        effect = "NO\_SCHEDULE"<br>      }<br>    ]<br>  }<br>} | <pre>map(object({<br>    instance_type = string<br>    capacity_type = string<br>    desired_size  = number<br>    min_size      = number<br>    max_size      = number<br>    disk_size     = number<br>    ami_type      = string<br>    labels        = map(string)<br>    taints = list(object({<br>      key    = string<br>      value  = string<br>      effect = string # NO_SCHEDULE, PREFER_NO_SCHEDULE, NO_EXECUTE<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_node_role_arn"></a> [node\_role\_arn](#input\_node\_role\_arn) | IAM role ARN for the EKS node groups | `string` | n/a | yes |
| <a name="input_product_name"></a> [product\_name](#input\_product\_name) | Product name for Backstage | `string` | `"EKS"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-west-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_node_group_arns"></a> [node\_group\_arns](#output\_node\_group\_arns) | The ARN (Amazon Resource Name) for each EKS node group, keyed by node group name. |
| <a name="output_node_group_instance_types"></a> [node\_group\_instance\_types](#output\_node\_group\_instance\_types) | The EC2 instance types used by each node group. |
| <a name="output_node_group_labels"></a> [node\_group\_labels](#output\_node\_group\_labels) | The Kubernetes labels assigned to each node group. |
| <a name="output_node_group_names"></a> [node\_group\_names](#output\_node\_group\_names) | The names of all EKS node groups created in this Terraform run. |
| <a name="output_node_group_role_arns"></a> [node\_group\_role\_arns](#output\_node\_group\_role\_arns) | The IAM role ARN associated with each node group. |
| <a name="output_node_group_scaling"></a> [node\_group\_scaling](#output\_node\_group\_scaling) | Scaling configuration (min, desired, max) for each node group. |
| <a name="output_node_group_statuses"></a> [node\_group\_statuses](#output\_node\_group\_statuses) | The current provisioning status of each EKS node group (e.g., ACTIVE, CREATING, UPDATING). |
| <a name="output_node_group_subnets"></a> [node\_group\_subnets](#output\_node\_group\_subnets) | The subnet IDs each node group is deployed into. |
| <a name="output_node_group_taints"></a> [node\_group\_taints](#output\_node\_group\_taints) | The Kubernetes taints assigned to each node group. |
<!-- END_TF_DOCS -->