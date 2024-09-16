variable "project_id" {
  description = "The GCP project ID"
}

variable "network_name" {
  type        = string
  description = "The name of the vpc network"
}

variable "region" {
  description = "The region to deploy the GKE cluster in"
  default     = "us-central1"
}

variable "machine_type" {
  description = "The machine type for the GKE cluster nodes"
  default     = "e2-medium"
}

variable "dev_zone" {
  type        = string
  description = "The name of the dev zone"
}

variable "prod_zone" {
  type        = string
  description = "The name of the prod zone"
}