locals {
  # Generate custom domain from repo name and base domain if not explicitly set
  custom_domain = var.custom_domain != "" ? var.custom_domain : "${lower(var.repo_name)}.${var.base_domain}"
}

resource "github_repository" "site" {
  name        = var.repo_name
  description = "Terraform + GitHub Pages demo"
  visibility  = "public"

  # Configure custom domain for GitHub Pages
  # Note: When using GitHub Actions deployment, the source branch here is ignored
  # but we still need it for Terraform. The actual deployment is handled by .github/workflows/deploy.yml
  pages {
    source {
      branch = "gh-pages"
      path   = "/"
    }
    cname = local.custom_domain
  }
}

# Note: CNAME file is generated during GitHub Actions deployment
# (see .github/workflows/deploy.yml) to avoid committing it to git
