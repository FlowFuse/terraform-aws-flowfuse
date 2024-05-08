data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid    = "0"
    effect = "Allow"
    actions = [
      "autoscaling:SetDesiredCapacity",
    "autoscaling:TerminateInstanceInAutoScalingGroup"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${module.eks_cluster.eks_cluster_id}"
      values   = ["owned"]
    }
  }
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeAutoScalingGroups",
      "ec2:DescribeLaunchTemplateVersions",
      "autoscaling:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations",
      "ec2:DescribeInstanceTypes"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name        = "${module.eks_cluster.eks_cluster_id}-cluster-autoscaler"
  path        = "/"
  description = "Kubernetes Cluster Autoscaler IAM Policy"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}
