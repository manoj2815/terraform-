variable "instance_name" {
    type = string 
   default = "TOMCAT"
}
variable "env" {
    type = string
    default = "PROD"
}
variable "ami_id" {
    type = string
    default = "ami-060f2cb962e997969"
}
variable "instance_type" {
    type = string 
    default = "t2.medium"
}
variable "a_zone" {
    type = string
    default = "ap-south-1b"
}
variable "security_group" {
    type = string 
    default = "aws_security_group.manoj.id"
}
variable "val_size" {
    type = number
    default = "20"
}
variable "bucket_name" {
    type = string
    default = "bucket.south.aws-s3"
}