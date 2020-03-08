# Getting the default subnet ids. Only 2 for this example
resource "aws_default_subnet" "default_az1" {
  availability_zone = "eu-west-2a"

  tags = {
    Name = "Default subnet for eu-west-2a"
    "kubernetes.io/cluster/example" = "shared"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "eu-west-2b"

  tags = {
    Name = "Default subnet for eu-west-2b"
    "kubernetes.io/cluster/example" = "shared"
  }
}