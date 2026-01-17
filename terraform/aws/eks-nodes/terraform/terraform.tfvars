cluster_name = "isaac-eks-cluster"

node_groups = {
  gpu-nodes = {
    instance_type = "g4dn.xlarge"
    ami_type      = "AL2023_x86_64_NVIDIA"
    capacity_type = "ON_DEMAND"
    desired_size  = 2
    min_size      = 2
    max_size      = 4
    disk_size     = 100 # GiB, scalable later
    labels = {
      workload = "gpu"
    }
    taints = [
      {
        key    = "nvidia.com/gpu.present"
        value  = "true"
        effect = "NO_SCHEDULE"
      }
    ]
  }
}