#An EKS cluster requires a number of worker nodes to schedule Kubernetes Pods

resource "aws_eks_node_group" "sales_order_system_aws_eks_node_group" {
    cluster_name    = "eks cluster"
    node_group_name = "eks worker node group"
    node_role_arn   = aws_iam_role.eks_worker_node_group_role.arn
    subnet_ids      = data.terraform_remote_state.app_network.outputs.subnet_ids

    scaling_config {
        desired_size    = 5
        max_size        = 10
        min_size        = 3
    }
}

resource "aws_iam_role" "eks_worker_node_group_role" {
    name = "eks_worker_node_group_role"

    assume_role_policy = jsonencode({
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
        Version = "2012-10-17"
    })
}

resource "aws_iam_role_policy_attachment" "sales-order-system-AmazonEKSWorkerNodePolicy" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role        = aws_iam_role.eks_worker_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "sales-order-system-AmazonEKS_CNI_Policy" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role        = aws_iam_role.eks_worker_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "sales-order-system-AmazonEC2ContainerRegistryReadOnly" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role        = aws_iam_role.eks_worker_node_group_role.name
}
