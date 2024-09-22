provider "google" {
  project = var.project_id
  region  = var.region
  # credentials = "~/project-432906-d71f478c4255.json"
  # use export for best practice security reason
  # export GOOGLE_APPLICATION_CREDENTIALS="~/project-432906-d71f478c4255.json"

}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
