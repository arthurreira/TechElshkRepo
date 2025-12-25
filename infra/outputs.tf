output "repository_url" {
  description = "GitHub repository URL"
  value       = github_repository.site.html_url
}

output "custom_domain" {
  description = "Configured custom domain for GitHub Pages"
  value       = local.custom_domain
}

output "custom_domain_url" {
  description = "Full URL with custom domain"
  value       = "https://${local.custom_domain}"
}

output "github_pages_url" {
  description = "Default GitHub Pages URL"
  value       = "https://${local.github_owner}.github.io/${var.repo_name}/"
}

output "dns_instructions" {
  description = "DNS configuration instructions"
  value       = <<-EOT
    Configure DNS with your registrar:
    - Type: CNAME
    - Name: ${split(".", local.custom_domain)[0]}
    - Value: ${local.github_owner}.github.io
    
    After DNS propagates, enable HTTPS in GitHub Pages settings.
  EOT
}

