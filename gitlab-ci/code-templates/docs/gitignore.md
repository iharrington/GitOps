# GitIgnore Templates

This section documents the `.gitignore` templates provided in this repository.

## Available Templates

- **Terraform / Terragrunt**  
  Ignores state files, `.terraform/` directories, plan files, and local caches.
- **Helm / Kubernetes**  
  Ignores packaged charts (`*.tgz`), lock files, chart cache directories, and release outputs.
- **Node / NPM**  
  Ignores dependencies (`node_modules`), build outputs (`dist`, `coverage`), logs, environment files (`.env`), IDE/editor files, and WSL/Windows artifacts like `*:Zone.Identifier`.


## Usage

Copy a template into your project:

```bash
cp ignore_files/terraform.gitignore .gitignore
# or
cp ignore_files/node.gitignore .gitignore
```

Merge or customize sections as needed for your stack.
