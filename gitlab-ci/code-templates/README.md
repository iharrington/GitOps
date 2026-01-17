# Code Templates

Reusable templates for projects across your organization. This repository centralizes
common boilerplate and best-practice files (e.g., `.gitignore`, `.editorconfig`, and more).

## Structure

- `gitignore/` — Collection of `.gitignore` templates for different stacks and tools
  (Terraform/Terragrunt, Helm/Kubernetes, General development).
- `docs/` — TechDocs (MkDocs) documentation for discoverability and guidance.

## Usage

Copy a template into your project, for example:

```bash
cp gitignore/terraform.gitignore .gitignore
```

Or, if this repository is included as a submodule/monorepo component, you can symlink:

```bash
ln -s ../code-templates/gitignore/terraform.gitignore .gitignore
```

## Contributing

1. Add or update a template under the appropriate directory.
2. Use clear filenames (e.g., `terraform.gitignore`, `helm.gitignore`, `general.gitignore`).
3. Update TechDocs pages under `docs/` if needed.
4. Open a Merge Request with a summary of changes and usage notes.
