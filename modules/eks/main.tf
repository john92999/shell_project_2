resource "aws_iam_role" "eks-cluster-role" {
    name = "eks-cluster-role"
    assume_role_policy = jsonencode(
        {
            Version = "2012-10-17"
            Statement = [
                {
                    Effect = "Allow"
                    Principal = {
                        Service = "eks.amazonaws.com"
                    }
                    Action = "sts:AssumeRole"
                }
            ]
        }
    )
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
    role = aws_iam_role.eks-cluster-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks-node-role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks-worker-node-policy" {
  role       = aws_iam_role.eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cni-policy" {
  role       = aws_iam_role.eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks-ecr-readonly" {
  role       = aws_iam_role.eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_security_group" "eks-cluster-sg" {
  name   = "eks-cluster-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "eks-cluster-sg" }
}


resource "aws_eks_cluster" "main" {
    name = var.cluster_name
    role_arn = aws_iam_role.eks-cluster-role.arn
    version = var.cluster_version
    vpc_config {
        subnet_ids = var.private_subnet_ids
        security_group_ids = [aws_security_group.eks-cluster-sg.id]
        endpoint_public_access  = false
        endpoint_private_access = true
    }
    depends_on = [aws_iam_role_policy_attachment.eks-cluster-policy]
    tags = { Name = var.cluster_name }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "main-node-group"
  node_role_arn   = aws_iam_role.eks-node-role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = [var.node_instance_type]

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-worker-node-policy,
    aws_iam_role_policy_attachment.eks-cni-policy,
    aws_iam_role_policy_attachment.eks-ecr-readonly,
  ]

  tags = { Name = "main-node-group" }
}
