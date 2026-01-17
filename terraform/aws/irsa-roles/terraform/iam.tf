###############
# FLUX - ECR IAM Role
###############
resource "aws_iam_role" "flux_irsa" {
  name = "flux-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.this.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            # Replace the following with your OIDC issuer + multiple service accounts
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" = [
              "system:serviceaccount:flux-system:helm-controller",
              "system:serviceaccount:flux-system:source-controller",
              "system:serviceaccount:flux-system:image-automation-controller",
              "system:serviceaccount:flux-system:image-reflector-controller",
              "system:serviceaccount:flux-system:kustomize-controller"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "flux_ecr_pull" {
  role       = aws_iam_role.flux_irsa.name
  policy_arn = "arn:aws-us-gov:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

###############
# GITLAB - EKS IAM Role
###############

resource "aws_iam_role" "gitlab_irsa" {
  name = "gitlab-runner-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws-us-gov:iam::${data.aws_caller_identity.current.id}:oidc-provider/sts.windows.net/${var.azure_tenant_id}/"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "sts.windows.net/${var.azure_tenant_id}/:sub" = "b917da2a-785b-4515-a4df-57ff1a3f142a",
            "sts.windows.net/${var.azure_tenant_id}/:aud" = "api://${var.eks_client_id}"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ec2_full" {
  role       = aws_iam_role.gitlab_irsa.name
  policy_arn = "arn:aws-us-gov:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy" "custom" {
  name = "GitLabRunnerEKS"
  role = aws_iam_role.gitlab_irsa.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:GetCallerIdentity",
          "eks:*"
        ],
        Resource = "*"
      }
    ]
  })
}

###############
# DevOps EKS Role
###############
resource "aws_iam_role" "devops_irsa" {
  name = "devops-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws-us-gov:iam::${data.aws_caller_identity.current.id}:role/aws-reserved/sso.amazonaws.com/us-gov-west-1/AWSReservedSSO_DevOps_98460eddafc27f5d"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "devops_eks_policy" {
  name = "devops-eks-access"
  role = aws_iam_role.devops_irsa.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:GetCallerIdentity",
          "eks:*"
        ],
        Resource = "*"
      }
    ]
  })
}

###############
# DBA EKS Role
###############
resource "aws_iam_role" "dba_irsa" {
  name = "dba-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws-us-gov:iam::${data.aws_caller_identity.current.id}:role/aws-reserved/sso.amazonaws.com/us-gov-west-1/AWSReservedSSO_DBA_6b2088514158e01a"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "DBA_eks_policy" {
  name = "dba-eks-access"
  role = aws_iam_role.dba_irsa.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:GetCallerIdentity",
          "eks:ListClusters",
          "eks:DescribeCluster"
        ],
        Resource = "*"
      }
    ]
  })
}


###############
# TERRAFORM IAM Role
###############

resource "aws_iam_role" "terraform_irsa" {
  name = "terraform-runner-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws-us-gov:iam::${data.aws_caller_identity.current.id}:oidc-provider/sts.windows.net/${var.azure_tenant_id}/"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "sts.windows.net/${var.azure_tenant_id}/:sub" = "729f9011-c51f-4175-9d64-b7d751dc06c4",
            "sts.windows.net/${var.azure_tenant_id}/:aud" = "api://${var.terraform_client_id}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_admin" {
  role       = aws_iam_role.terraform_irsa.name
  policy_arn = "arn:aws-us-gov:iam::aws:policy/AdministratorAccess"
}
