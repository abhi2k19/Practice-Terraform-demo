

variable "bucket_name" {
    type = string
    description = "Name of the S3 bucket"
    
}

variable "environment" {
    description = "Environment (eg. dev, prod, stage)"
    type = string
} 
