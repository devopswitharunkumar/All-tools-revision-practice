locals {
  instance_names = {
    dev = {
        mongodb = "t3.small"
        mysql    = "t3.small"
        shipping = "t3.small"
        redis    = "t3.micro"
        web      = "t3.micro"
    },
    test = {
        mongodb = "t3.small"
        mysql    = "t3.small"
        shipping = "t3.small"
        redis    = "t3.micro"
        web      = "t3.micro"
    }
  }
}