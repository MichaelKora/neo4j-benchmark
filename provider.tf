provider "google" {
  credentials = file("credentials.json")
  project     = "bakdata-terraform-testing"
  /* region      = "europe-west3" */
}
