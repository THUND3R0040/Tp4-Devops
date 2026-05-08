variable "project_name" {
    type = string
    description = "Project name used for resource naming"
    default = "tp4" 
}
variable "environment" {
    type = string
    description = "Environment name (dev, staging, prod)"
    default = "k8s"
}
