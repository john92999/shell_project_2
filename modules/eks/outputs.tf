output "cluster_name"     { value = aws_eks_cluster.main.name }
output "cluster_endpoint" { value = aws_eks_cluster.main.endpoint }
output "cluster_sg_id"    { value = aws_security_group.eks-cluster-sg.id }