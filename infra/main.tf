locals {
  # Generate custom domain from repo name and base domain if not explicitly set
  custom_domain = var.custom_domain != "" ? var.custom_domain : "${lower(var.repo_name)}.${var.base_domain}"
}

resource "github_repository" "site" {
  name        = var.repo_name
  description = "Terraform + GitHub Pages demo"
  visibility  = "public"

  pages {
    source {
      branch = "main"
      path   = "/"
    }
    cname = local.custom_domain
  }
}

# Generate CNAME file for GitHub Pages custom domain
resource "local_file" "cname" {
  content  = local.custom_domain
  filename = "${path.module}/../app/CNAME"
}
