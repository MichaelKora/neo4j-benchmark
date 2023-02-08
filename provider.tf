provider "google" {
  credentials = file("credentials.json")
  project     = "neo4j-benchmark-372917"
  region      = "europe-west3"
}
