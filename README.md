# GCP Infrastructure Setup using Terraform, Ansible, and Jenkins

This guide provides step-by-step instructions to set up Google Cloud Platform (GCP) infrastructure, configure Terraform and Ansible, and deploy a CI/CD pipeline using Jenkins. The steps are divided into phases for easy navigation.

## Prerequisites
Ensure that the following tools are installed:
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- [Terraform](https://www.terraform.io/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Jenkins](https://www.jenkins.io/download/)

## Step 01: Google Cloud Setup

### Install Google Cloud SDK
To install the Google Cloud SDK, run:
```bash
chmod +x ./scripts/install_gcloud.sh
./scripts/install_gcloud.sh
```
### Authenticate with GCP
Authenticate to GCP by running:

```bash
gcloud auth application-default login
```
In certain environments (like headless servers), you can use the following command: (optional)

```bash
gcloud auth application-default login --no-launch-browser
```
### Billing and Project Setup
List billing accounts:

```bash
gcloud beta billing accounts list
```
Create a new project:

```bash
gcloud projects create <PROJECT_ID> --name="<PROJECT_NAME>"
```
example:
```bash
gcloud projects create shopvory-ecommerce --name=shopvory
```
Link the project to a billing account:

```bash
gcloud beta billing projects link <PROJECT_ID> --billing-account=<ACCOUNT_ID>
```
Set the project as the default:

```bash
gcloud config set project <PROJECT_ID>
```
Verify the project configuration:

```bash
gcloud config get-value project
```
### Enable Required APIs
Enable the necessary Google Cloud services:

```bash
chmod +x scripts/gcp_service_apis.sh
scripts/gcp_service_apis.sh
```
or 
```bash
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable storage.googleapis.com
```
### Google Cloud Storage Setup
Create a storage bucket:

```bash
gcloud storage buckets create gs://YOUR_BUCKET_NAME --location=REGION
```
(Optional) Enable versioning for the bucket:

```bash
gcloud storage buckets update gs://YOUR_BUCKET_NAME --versioning
```
### Service Account Creation
Create a Terraform service account by running the script:
Add your Project ID and Service account name:
```bash
PROJECT_ID="shopvory-ecommerce"
SERVICE_ACCOUNT_NAME="tf-svc-account"
```
```bash
chmod +x scripts/create_tf_svc_account.sh
./scripts/create_tf_svc_account.sh
```
Ensure that you edit the script with the required details before running.
or you can create manually based on roles and permissions.



