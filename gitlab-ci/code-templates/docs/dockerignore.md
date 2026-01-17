## DockerIgnore Template

This document describes the `.dockerignore` template provided in this repository.

### Purpose

The `.dockerignore` file excludes unnecessary files from Docker build contexts to:

- Reduce build context size and speed up image builds
- Prevent sensitive or local-only files from being included in images
- Avoid accidental inclusion of system, editor, or CI artifacts

### Contents

The template ignores files in the following categories:

- **Git / VCS:** `.git/`, `.gitignore`, `.gitattributes`
- **System Files:** `.DS_Store`, `Thumbs.db`, `ehthumbs.db`, `Desktop.ini`, `$RECYCLE.BIN/`, `*.lnk`, `*:Zone.Identifier`
- **Node / Dependencies:** `node_modules/`, `npm-debug.log`, `yarn-debug.log`, `yarn-error.log`
- **Build Output:** `dist/`, `dist-types/`, `build/`, `coverage/`
- **Local Env / Config:** `.env`, `.env.*`, `*.local.yaml`, `*-credentials.yaml`
- **Docker / Compose:** `docker-compose.override.yml`, `docker-compose.override.*.yml`
- **IDE / Editor:** `.idea/`, `.vscode/`, `*.swp`, `*.swo`, `.history`
- **Docs / Site:** `site/`, `techdocs-out/`
- **Logs / Temporary / Backup:** `*.log`, `*.tmp`, `*.bak`, `*.orig`, `*~`

### Usage

Copy the template into your project:

```bash
cp ignore_files/docker.dockerignore .dockerignore
```

Merge or customize sections as needed for your stack.
