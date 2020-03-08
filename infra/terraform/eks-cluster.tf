# EKS cluster control plane
resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = ["${aws_default_subnet.default_az1.id}", "${aws_default_subnet.default_az2.id}"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSServicePolicy,
  ]
}

# EKS node
resource "aws_eks_node_group" "example-node" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "example-node"
  node_role_arn   = aws_iam_role.example-node.arn
  subnet_ids      = ["${aws_default_subnet.default_az1.id}", "${aws_default_subnet.default_az2.id}"]
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

output "endpoint" {
  value = "${aws_eks_cluster.example.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.example.certificate_authority.0.data}"
}