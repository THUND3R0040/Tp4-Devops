module "infrastructure" {
  source = "../../../modules/kubernetes-cluster"

  project_name         = var.project_name
  environment          = var.environment
  location             = var.location
  vm_size              = var.vm_size
  node_count           = var.node_count
  tags = {
    Project     = "TaskManager"
    Environment = "Production-k8s"
    ManagedBy   = "Terraform"
    CostCenter  = "DevOps-Portfolio"
  }
}