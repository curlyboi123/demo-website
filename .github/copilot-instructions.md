# AI Coding Agent Instructions

## Project Overview

This is an **Infrastructure-as-Code (IaC) project** using **OpenTofu** (Terraform-compatible) to manage cloud infrastructure. The project is structured around a single Terraform state file stored in S3 (`eu-west-1` region, bucket: `john-bucket-terraform-state`).

**Key Tech Stack:**
- OpenTofu 1.11.5 (not Terraform - uses `tofu` CLI instead of `terraform`)
- S3 backend with state locking enabled
- Task management via `mise` (modern tool runner)

## Project Structure

- **`terraform/`**: All infrastructure definitions
  - `backend.tf`: S3 backend configuration (don't modify bucket/key names)
  - `locals.tf`: Local variables (typically for derived values)
  - `variables.tf`: Input variables (environment-specific)
  - `main.tf`: Primary resource definitions
  - `providers.tf`: Provider configurations
  - `outputs.tf`: Output values exposed from the state
  - `terraform.tf`: Terraform/OpenTofu version constraints

- **`mise.toml`**: Task definitions for common operations
- **`.gitignore`**: Excludes `.terraform/` directory

## Essential Workflows

### Common Tasks (via `mise`)

Run these commands from the workspace root:

```bash
mise run init    # Initialize Terraform (tofu init)
mise run plan    # Review planned infrastructure changes
mise run apply   # Apply approved infrastructure changes (auto-approved)
```

**Important**: All tasks execute in the `terraform/` directory. Use `tofu` CLI directly if needed for advanced operations.

### State Management

- State is **remote** (S3-backed with locking) - never commit `terraform.tfstate` locally
- Lock files are managed automatically by S3 backend
- Use AWS credentials for S3 access (ensure AWS_PROFILE or credentials are configured)

## Conventions & Patterns

### Variable Organization
- **`variables.tf`**: Only variable definitions (type, description, defaults)
- **`locals.tf`**: Computed values derived from variables or resource attributes
- **`main.tf`**: Resources that reference both vars and locals

### Naming Conventions
- Use snake_case for resource names and variables
- Resource types follow Terraform provider conventions (e.g., `aws_instance`, `aws_s3_bucket`)
- Avoid hardcoding values - use variables for environment-specific config

### Backend Configuration
- S3 state bucket: `john-bucket-terraform-state`
- State key: `github.com/demo-website/terraform.tfstate`
- Region: `eu-west-1`
- Lock file: **enabled** (use_lockfile = true) - prevents concurrent modifications

## When Adding Features

1. **Define variables first** in `variables.tf` if new inputs are needed
2. **Add computed values** to `locals.tf` if they depend on variables or existing resources
3. **Implement resources** in `main.tf`
4. **Export values** via `outputs.tf` if other systems need them
5. **Run `mise run plan`** to validate before applying

## Debugging Tips

- Use `tofu plan` directly in `terraform/` for detailed output
- Check AWS credentials if state operations fail
- Review `terraform.lock.hcl` changes in git diffs (commit it for reproducibility)
- If state lock is stuck, check AWS S3 lock objects in the bucket

## External Dependencies

- **AWS account** with S3 bucket access (required for state)
- **OpenTofu 1.11.5** (managed by `mise` - automatic)
- AWS CLI credentials (via environment variables or ~/.aws/credentials)

## Project-Specific Notes

- This is a **minimal infrastructure project** (most files are currently empty)
- State locking is enabled - multiple engineers can safely work concurrently
- No Terraform modules are currently used (everything is in root config)
