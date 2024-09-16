resource "google_service_account" "this" {
  account_id   = var.account_id
  display_name = var.display_name
  project      = var.project_id
}

resource "google_project_iam_member" "roles" {
  for_each = var.roles

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.this.email}"
}
