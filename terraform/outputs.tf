output "vpc_id" {
  value = aws_vpc.demo_vpc.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.demo_eks_cluster.name
}

output "eks_node_group_name" {
  value = aws_eks_node_group.demo_node_group.node_group_name
}