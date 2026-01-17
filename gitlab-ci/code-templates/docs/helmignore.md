## HelmIgnore Template

This document describes the `.helmignore` template provided in this repository.

### Purpose

The `.helmignore` file excludes unnecessary files from Helm chart packages to:

- Reduce chart package size and speed up `helm package` operations
- Prevent sensitive or local-only files from being included in Helm charts
- Avoid accidental inclusion of system, editor, or CI artifacts

### Contents

The template ignores files in the following categories:

- **Version Control / VCS:** `.git/`, `.gitignore`, `.gitattributes`, `.hg/`, `.hgignore`, `.bzr/`, `.bzrignore`, `.svn/`
- **System / OS Files:** `.DS_Store`, `Thumbs.db`, `ehthumbs.db`, `Desktop.ini`, `$RECYCLE.BIN/`, `*.lnk`, `*:Zone.Identifier`
- **Node / Dependencies:** `node_modules/`, `npm-debug.log`, `yarn-debug.log`, `yarn-error.log`
- **Build Output / Artifacts:** `dist/`, `dist-types/`, `build/`, `coverage/`, `site/`, `techdocs-out/`
- **Local Environment / Config:** `.env`, `.env.*`, `*.local.yaml`, `*-credentials.yaml`
- **Docker / Compose Overrides:** `docker-compose.override.yml`, `docker-compose.override.*.yml`
- **IDE / Editor:** `.idea/`, `.vscode/`, `*.tmproj`, `*.swp`, `*.swo`, `.project`, `.history`
- **Logs / Temporary / Backup:** `*.log`, `*.tmp`, `*.bak`, `*.orig`, `*~`

### Usage

Copy the template into your Helm chart project:

```bash
cp ignore_files/helm.helmignore .helmignore
```

Merge or customize sections as needed for your stack.

>Tip: Helm ignores support shell globs and negation (!pattern), useful for excluding files tracked in Git but not needed in chart packages.
