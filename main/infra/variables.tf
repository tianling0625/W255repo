variable "google_client_id" {
  type      = string
  sensitive = true
}

variable "google_client_secret" {
  type      = string
  sensitive = true
}

variable "google_auth_callback_url_base" {
  type      = string
  default   = "https://datacollector.mids255.com"
  sensitive = true
}

variable "session_secret" {
  type      = string
  sensitive = true
}
