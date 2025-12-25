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


## Custom Domain Setup

This project automatically creates a custom subdomain using your **repository name** (lowercased). For example, if your repo is named `TechElshkRepo`, it will create `techelskrepo.your-domain.com`.

### How It Works

- **Automatic Subdomain**: By default, the custom domain is generated as `${lower(repo_name)}.${base_domain}`
  - Repository name: `TechElshkRepo` → Subdomain: `techelskrepo.example.com`
  - Repository name: `MyApp` → Subdomain: `myapp.example.com`
  - The repository name is automatically lowercased for the subdomain
- **Custom Subdomain**: You can override this by setting `custom_domain` variable in your `terraform.tfvars`
- **Base Domain**: Configure your base domain in the `base_domain` variable (default can be set in `terraform.tfvars`)

### Terraform Configuration

Terraform automatically handles the custom domain setup:
1. **Configures GitHub Pages** with the custom domain (sets it in repository settings automatically)
2. **CNAME file is generated during deployment** (not committed to git for security) - see below

**No manual configuration needed in GitHub Pages settings** - Terraform does it for you when you apply!

**Security Note:** The CNAME file is generated dynamically during GitHub Actions deployment and is not committed to the repository. You need to set a repository variable:
- Go to: Repository Settings → Secrets and variables → Actions → Variables
- Add variable: `BASE_DOMAIN` with your base domain (e.g., `example.com`)

### DNS Configuration

After applying Terraform, you need to configure DNS with your domain registrar:

1. **Log in to your domain registrar** (where you manage your base domain)

2. **Add a CNAME record**:
   - **Type**: `CNAME`
   - **Name/Host**: Your repository name in lowercase (e.g., if repo is `TechElshkRepo`, use `techelskrepo`)
   - **Value/Points to**: `your-username.github.io` (replace `your-username` with your GitHub username)
   - **TTL**: 3600 (or your preferred value)

   Example: If your repository is named `TechElshkRepo` and base domain is `example.com`:
   ```
   Type: CNAME
   Name: techelskrepo
   Value: your-username.github.io
   ```
   This will make your site available at `https://techelskrepo.example.com`

3. **Wait for DNS propagation** (usually 5-60 minutes)

4. **Enable HTTPS in GitHub** (after DNS propagates):
   - Go to your repository → Settings → Pages
   - Under "Custom domain", you should see your domain (e.g., `techelskrepo.example.com`) already configured ✅
   - Check the box for **"Enforce HTTPS"**
   - GitHub will automatically provision an SSL certificate (may take a few minutes to 24 hours)

**Note:** Terraform automatically added the custom domain to GitHub Pages settings. You only need to manually enable HTTPS after DNS is configured.

### Testing

Once DNS is configured, you can access your site at:
- `https://{lowercase-repo-name}.{base-domain}` (e.g., `https://techelskrepo.example.com` if repo is `TechElshkRepo`)

The default GitHub Pages URL will still work, but GitHub will automatically redirect to your custom domain once configured.

### Troubleshooting

#### 404 Error: "There isn't a GitHub Pages site here"

If you see a 404 error, check these steps:

1. **Verify Pages Source is set to "GitHub Actions"**:
   - Go to repository → Settings → Pages
   - Under "Source", it should say **"GitHub Actions"** (not "Deploy from a branch")
   - If it's set to a branch, you need to change it:
     - Click on the source dropdown
     - Select "GitHub Actions" (if not available, the deploy workflow needs to run first)

2. **Check that the deployment workflow ran successfully**:
   - Go to repository → Actions tab
   - Look for "Deploy static content to Pages" workflow
   - Make sure it completed successfully (green checkmark)
   - If it failed, check the logs and fix any errors

3. **Ensure the CNAME file exists**:
   - After Terraform runs, a `CNAME` file should be created in the `app/` directory
   - This file will be included in the deployment automatically
   - Verify it contains your custom domain (e.g., `techelskrepo.example.com`)

4. **Trigger a new deployment**:
   - Make a small change and push to `main` branch, OR
   - Go to Actions → "Deploy static content to Pages" → Run workflow (manual trigger)

#### Other Common Issues

- **DNS not resolving**: Wait a few minutes for DNS propagation, or check your DNS settings
- **SSL certificate pending**: This can take up to 24 hours after DNS is configured
- **Custom domain not showing in Pages settings**: Run Terraform apply to configure it automatically
