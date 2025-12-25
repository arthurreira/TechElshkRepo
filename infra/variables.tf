variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "repo_name" {
  description = "Repository name"
  type        = string
  default     = "TechElshkRepo"
}

variable "base_domain" {
  description = "Base domain for custom subdomain (e.g., example.com)"
  type        = string
  default     = ""
}

variable "custom_domain" {
  description = "Custom domain for GitHub Pages (e.g., myapp.example.com). If not set, will auto-generate from repo_name as {lower(repo_name)}.{base_domain}"
  type        = string
  default     = ""
}
