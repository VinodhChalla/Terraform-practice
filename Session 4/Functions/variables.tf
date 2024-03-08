variable "aws_accounts" {
  type = map
  default = {
    "us-east-1" = "367591148304" # these are official AWS Account ID
    "us-east-2" = "367591148304"
  }
}
#how you get value from map
# map_name("key")
# aws_accounts["ap-south-1"]
