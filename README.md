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

To manage infrastructure with Terraform, you'll need to create a dedicated service account in GCP. You can either create the service account by running a script or manually through the Google Cloud Console.

#### Option 1: Create a Service Account using a Script

Follow these steps to create a Terraform service account via the provided script:

1. Set your GCP project ID and service account name as environment variables:

    ```bash
    PROJECT_ID="shopvory-ecommerce"
    SERVICE_ACCOUNT_NAME="tf-svc-account"
    ```

2. Ensure the script has executable permissions:

    ```bash
    chmod +x scripts/create_tf_svc_account.sh
    ```

3. Run the script to create the service account:

    ```bash
    ./scripts/create_tf_svc_account.sh
    ```

> **Note:** Before running the script, make sure to edit it with the correct roles, permissions, and project-specific details as necessary.

#### Option 2: Manual Creation via the GCP Console

Alternatively, you can manually create a service account through the Google Cloud Console or the `gcloud` CLI by following these steps:

1. Create the service account:

    ```bash
    gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
      --display-name="Terraform Service Account"
    ```

2. Assign the required roles and permissions to the service account. For example, to grant the `roles/editor` role:

    ```bash
    gcloud projects add-iam-policy-binding $PROJECT_ID \
      --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/editor"
    ```

3. (Optional) If you want to use more fine-grained permissions, assign specific roles as needed based on the scope of the infrastructure your Terraform configuration will manage.

> For more details on available roles, refer to the [Google Cloud IAM Documentation](https://cloud.google.com/iam/docs/understanding-roles).

## Step 02: Terraform & Ansible Setup
Install Terraform
Run the following script to install Terraform:

```bash
chmod +x scripts/install_terraform.sh
./scripts/install_terraform.sh
```
SSH Key Generation for Ansible
Generate SSH keys for Ansible:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/ansible_ed25519 -C ansible
```

Ansible Configuration

Add the following configuration to your Ansible settings (e.g., in `ansible.cfg`):

```ini
[defaults]
inventory = inventory/ansible_inventory.json
remote_user = ansible
private_key_file = /home/dev/.ssh/ansible_ed25519
```
Create GCP Infrastructure with Terraform

Run the Scripts to Create Infrastructure

1. Create CI/CD Infrastructure

To set up the CI/CD infrastructure, run the following script:

```bash
cd scripts
chmod +x create_cicd_infra.sh
./create_cicd_infra.sh
```
2. Create GKE Infrastructure
To create the GKE (Google Kubernetes Engine) infrastructure, run the following script in the background:

```bash
chmod +x create_gke_infra.sh
./create_gke_infra.sh &
```

## Step 03: Jenkins Setup

Initial Jenkins Configuration
- Install Jenkins and configure default plugins.
- Login and configure Jenkins.

Install Jenkins Plugins
Install the following Jenkins plugins:
- Docker
- Kubernetes
- Kubernetes CLI
- Multibranch Pipeline Webhook
- SonarQube
- Nodejs
  
Configure Jenkins Tools
- Docker
- NodeJS
- SonarQube
  
Add Credentials in Jenkins
- Docker Hub credentials
- Jenkins service account JSON key
- GitHub credentials
- SonarQube credentials

Create a Pipeline in Jenkins

Click on "New Item" in the Jenkins dashboard.

Enter a name for your pipeline (e.g., MyProjectPipeline).

Select "Pipeline" and click "OK".

In the configuration screen:

Scroll down to Pipeline section.
Under Definition, select "Pipeline script from SCM".
Under SCM, select "Git".
Enter the repository URL of your project (e.g., from GitHub or GitLab).
If required, add credentials for accessing the repository.
In the Script Path, enter Jenkinsfile (if it's located in the root of your repository).
Add secrets for Webhooks.
Save the configuration.

Configure Webhooks (GitHub Example)

GitHub Webhook Configuration
To trigger the pipeline automatically when changes are pushed to the repository, set up a webhook in GitHub:

Go to your GitHub repository.

Click on "Settings" > "Webhooks" > "Add webhook".

In the Payload URL field, enter your Jenkins server URL followed by /github-webhook/, for example:

```text
http://your-jenkins-url/github-webhook/
```
Set the Content type to application/json.

Choose the trigger events for the webhook. To trigger builds on every push, select "Just the push event".

Click "Add webhook".

Run the Pipeline
- Run the Jenkins pipeline.
- Trigger the pipeline using a webhook.

## Step 04: Destroying the Infrastructure
Cleanup CI/CD and GKE Infrastructure
Run the following scripts to destroy the infrastructure:

```bash
cd scripts
chmod +x destroy_cicd_infra.sh
 ./destroy_cicd_infra.sh
chmod +x destroy_gke_infra.sh
./destroy_gke_infra.sh
```
Delete the GCP Storage Bucket
Delete the Terraform state bucket and its contents:

```bash
gcloud storage rm -r gs://<BUCKET_NAME>
gcloud storage buckets delete gs://<BUCKET_NAME>
```
Delete the GCP Project
Finally, delete the GCP project:

```bash
gcloud projects delete <PROJECT_ID>
```

Conclusion
This guide helps you to quickly set up GCP infrastructure, CI/CD pipelines using Jenkins, and manage resources using Terraform and Ansible. Follow the cleanup steps to tear down the environment when it is no longer needed.


