# TechElshkRepo

## What I Learned

Through this project, I gained hands-on experience with **Infrastructure as Code (IaC)** and modern DevOps practices using Terraform and GitHub. Here's what I learned:

### Infrastructure as Code (IaC)
- **Terraform Fundamentals**: Learned how to define and manage infrastructure using declarative configuration files
- **Resource Management**: Understood how Terraform resources represent infrastructure components (like GitHub repositories)
- **State Management**: Discovered how Terraform tracks the current state of infrastructure
- **Plan & Apply Workflow**: Mastered the `terraform plan` and `terraform apply` workflow for safe infrastructure changes

### Terraform Configuration
- **Providers**: Worked with the GitHub provider to interact with GitHub's API
- **Variables**: Used variables for reusable and configurable infrastructure definitions
- **Outputs**: Defined and used output values to extract information about infrastructure
- **File Organization**: Learned best practices for organizing Terraform configurations across multiple files

### GitHub Integration
- **Repository Management**: Automated GitHub repository creation and configuration via Terraform
- **GitHub Pages Setup**: Configured static site hosting using GitHub Pages through Infrastructure as Code
- **API Authentication**: Understood different authentication methods (Personal Access Tokens, GITHUB_TOKEN)

### CI/CD with GitHub Actions
- **Automated Infrastructure Deployment**: Set up GitHub Actions workflows to automatically deploy infrastructure changes
- **Secret Management**: Learned secure practices for handling sensitive tokens in CI/CD pipelines
- **Workflow Automation**: Understood how to integrate Terraform into deployment pipelines

### Security Best Practices
- **Secret Management**: Learned to keep sensitive tokens out of version control
- **Environment Variables**: Used environment variables and `.tfvars` files for local development
- **CI/CD Security**: Implemented secure practices for managing credentials in automated workflows

### Web Development Integration
- **Static Site Deployment**: Deployed a simple web application (HTML/CSS/JavaScript) using GitHub Pages
- **Infrastructure-Driven Deployment**: Saw how infrastructure changes can automatically trigger deployments

## Terraform + GitHub Actions

- Terraform configs live in `infra/`.
- **All Terraform operations run automatically via GitHub Actions** - no local setup required!
- The workflow uses `GITHUB_TOKEN` automatically (no Personal Access Token needed).

### How It Works

When you push changes to the `infra/` directory (or trigger manually):

1. **GitHub Actions workflow runs** (`.github/workflows/terraform.yml`)
2. **Terraform validates** your configuration
3. **Terraform plans** the changes (shows what will be created/modified)
4. **Terraform applies** automatically on `main` branch pushes

### Workflow Triggers

The Terraform workflow runs on:
- **Push to `main`** branch when `infra/` files change
- **Pull requests** to `main` (plan only, no apply)
- **Manual trigger** via GitHub Actions UI (`workflow_dispatch`)

### Authentication

- ✅ Uses `GITHUB_TOKEN` automatically (no configuration needed!)
- ✅ Has permissions to manage repositories and GitHub Pages settings
- ✅ Secure and automatically scoped to your repository

### Viewing Results

- Check the **Actions** tab in GitHub to see workflow runs
- Terraform outputs (like custom domain) are shown in the workflow logs

### Security

- Do not commit real tokens. Use env vars or untracked `.tfvars`.
- Use `GITHUB_TOKEN` for read-only operations on this repo in CI.
- Use a PAT when administrative actions are required.

## Custom Domain Setup

This project is configured to use a custom subdomain like `app.arthurreira.dev` (where `app` is automatically generated from the repository name, or can be customized).

### How It Works

- **Automatic Subdomain**: By default, the custom domain is generated as `${repo_name}.${base_domain}` (e.g., `techelskrepo.arthurreira.dev`)
- **Custom Subdomain**: You can override this by setting `custom_domain` variable in your `terraform.tfvars`

### Terraform Configuration

The custom domain is configured in Terraform and a `CNAME` file is automatically generated in the `app/` directory. When you apply Terraform, it will:
1. Configure GitHub Pages with the custom domain
2. Generate the `CNAME` file in your app directory

### DNS Configuration

After applying Terraform, you need to configure DNS with your domain registrar:

1. **Log in to your domain registrar** (where you manage `arthurreira.dev`)

2. **Add a CNAME record**:
   - **Type**: `CNAME`
   - **Name/Host**: The subdomain part (e.g., `app` or `techelskrepo`)
   - **Value/Points to**: `arthurreira.github.io`
   - **TTL**: 3600 (or your preferred value)

   Example for `app.arthurreira.dev`:
   ```
   Type: CNAME
   Name: app
   Value: arthurreira.github.io
   ```

3. **Wait for DNS propagation** (usually 5-60 minutes)

4. **Enable HTTPS in GitHub**:
   - Go to your repository → Settings → Pages
   - Under "Custom domain", check "Enforce HTTPS"
   - GitHub will automatically provision an SSL certificate

### Testing

Once DNS is configured, you can access your site at:
- `https://app.arthurreira.dev` (or your configured subdomain)

The old GitHub Pages URL (`https://arthurreira.github.io/TechElshkRepo/`) will still work, but GitHub will automatically redirect to your custom domain once configured.

### Troubleshooting

- **DNS not resolving**: Wait a few minutes for DNS propagation, or check your DNS settings
- **SSL certificate pending**: This can take up to 24 hours after DNS is configured
- **404 errors**: Make sure the `CNAME` file exists in your `app/` directory and contains the correct domain
