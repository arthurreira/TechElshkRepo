locals {
  # Extract just the repo name if full_name (owner/repo) is provided
  repo_name = length(regexall("/", var.repo_name)) > 0 ? split("/", var.repo_name)[1] : var.repo_name

  # Generate custom domain from repo name and base domain if not explicitly set
  custom_domain = var.custom_domain != "" ? var.custom_domain : "${lower(local.repo_name)}.${var.base_domain}"
}

# Manage existing repository
resource "github_repository" "site" {
  name        = local.repo_name
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

  lifecycle {
    # Only manage pages configuration, ignore other changes
    ignore_changes = [
      description,
      visibility,
    ]
  }
}

locals {
  # Extract GitHub owner from repository full_name (format: owner/repo)
  github_owner = split("/", github_repository.site.full_name)[0]
}

# Note: CNAME file is generated during GitHub Actions deployment
# (see .github/workflows/deploy.yml) to avoid committing it to git
