resource "aws_instance" "mi" {
    provider = aws.south
    tags = {
        Name = var.instance_name
        Environment = var.env
    }
    ami = var.ami_id
    instance_type = var.instance_type
    availability_zone = var.a_zone
    vpc_security_group_ids = [var.security_group]
    root_block_device {
        volume_size = var.val_size
    }
}

 resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name

 }
 resource "aws_s3_bucket_ownership_controls" "oc" {
    bucket = aws_s3_bucket.bucket.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
 }
 resource "aws_s3_bucket_acl" "acl" {
    bucket = aws_s3_bucket.bucket.id
    depends_on = [aws_s3_bucket_ownership_controls.oc]
    acl = "private"
 }
 resource "aws_s3_bucket_versioning" "vc" {
    bucket = aws_s3_bucket.bucket.id
    versioning_configuration {
        status = "Enabled"
    }
 }
resource "aws_vpc" "vp" {
    tags = {
        Name = "south-vpc1"
    }
    cidr_block = "10.0.0.0/16"
    instance_tenancy ="default"
    enable_dns_hostnames = "true"
}

resource "aws_subnet" "sub1" {
    tags = {
        Name = "south-subnet1"
    }
    vpc_id = aws_vpc.vp.id
    availability_zone = "ap-south-1a"
    cidr_block = "10.1.0.0/24"
    map_public_ip_on_launch = "true"
}
resource "aws_subnet" "sub2" {
    tags = {
        Name = "south-subnet2"
    }
    vpc_id = aws_vpc.vp.id
    availability_zone = "ap-south-1b"
    cidr_block = "10.2.0.0/24"
    map_public_ip_on_launch = "true"
}

resource "aws_internet_gateway" "igw" {
    tags = {
        Name = "south-IGW"
    }
    vpc_id = aws_vpc.vp.id
}

resource "aws_route_table" "route" {
    tags = {
        Name = "south-route"
    }
    vpc_id = aws_vpc.vp.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}
resource "aws_route_table_association" "public_subnet_association-dc" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.route.id
}
resource "aws_route_table_association" "public_subnet_association-csk" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.route.id
}
resource "aws_security_group" "sg" {
    name = "tomcat"
    vpc_id = aws_vpc.vp.id
    provider = aws.south

ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks =["0.0.0.0/0"]
}
egress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks =["0.0.0.0/0"]
}
ingress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks =["0.0.0.0/0"]
}
egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks =["0.0.0.0/0"]
}
}

