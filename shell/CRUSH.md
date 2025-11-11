# CRUSH.md

This is a collection of shell utility scripts for common development and system administration tasks. The scripts are designed to be lightweight, portable, and dependency-aware.

## Directory Structure

- `/bin/` - Executable shell scripts
- `/etc/` - Configuration files sourced by scripts

## Key Scripts

### Git Workflow (`g`)
A comprehensive git wrapper that provides shortcuts for common git operations:
- `g s` - git status
- `g st` - interactive staging with gum
- `g cm` - git commit with interactive prompts
- `g bc` - interactive branch checkout with fzf
- `g bm` - branch manager (delete, update, rebase)
- `g au` - add, AI commit, and push
- `g install` - install shell aliases

### Container Utilities
- `dpl` - Docker pull helper supporting multiple registries and mirrors
- `debugc` - Debug containers by sharing PID/network/volumes
- `explore` - File sharing server with multiple backends (filebrowser, samba, ftp, nfs, webdav)

### System Tools
- `k` - Kubernetes wrapper with config/namespace management
- `gov` - Go version manager with fzf selection
- `px` - Proxy configuration manager (zsh only)
- `trash` - Safer file deletion with backup/recovery
- `upload` - File uploader with curl
- `wip` - Network information display
- `aifortune` - AI-powered fortune generator

## Configuration

Scripts source configuration from `~/.local/etc/scriptname.conf`. Create these files as needed:

- `~/.local/etc/g.conf` - Git wrapper config (AI commit settings)
- `~/.local/etc/px.conf` - Proxy configuration
- `~/.local/etc/upload.conf` - Upload server settings
- `~/.local/etc/debugc.conf` - Debug container settings
- `~/.local/etc/explore.conf` - File server settings
- `~/.local/etc/aifortune.conf` - AI fortune settings

## Dependencies

Most scripts require standard Unix tools:
- `curl`, `jq`, `docker`, `kubectl` (context-dependent)
- `fzf` for interactive selection
- `gum` for git staging/commit workflows
- `cowsay`, `lolcat` for aifortune (optional)

## Script Patterns

- All scripts are executable and start with `#!/bin/bash` or `#!/bin/sh`
- Configuration files are sourced from `~/.local/etc/`
- Error handling uses `set -e` where appropriate
- Functions are documented with comments
- Color output is used for better user experience
- FZF is used for interactive selection
- Docker containers are run with `--rm` for cleanup

## Installation

Scripts should be placed in `/bin/` and made executable. Configuration files go in `/etc/` or symlinked to `~/.local/etc/`.

## Common Commands

### Git Workflow
```bash
# Interactive staging with gum
g st

# Conventional commit with gum prompts
g cm

# Branch management
g bm          # Launch interactive branch manager
g bc          # Checkout branch with fzf

# Quick status check
g s           # git status

# Add, AI commit, and push
g au
```

### Docker Operations
```bash
# Pull from different registries/mirrors
dpl ubuntu:latest
dpl --mirror ghcr-mirror.io ghcr.io/user/repo:tag

# Debug running container
debugc <container_id>

# Share files via web interface
explore /path/to/directory
```

### System Management
```bash
# Kubernetes with config management
k config      # Change kubeconfig
k namespace   # Change namespace
k get pods    # kubectl with saved config

# Go version management
gov           # Select Go version
gov -r        # Select from remote versions

# Proxy configuration
source px -l  # List proxies
source px -s clash  # Set proxy
source px -c  # Clear proxy

# Safe file operations
trash file.txt        # Move to trash
trash recover filename  # Recover from trash
trash clean           # Clean old trash
```

## Testing

No formal test suite. Scripts are designed to be self-documenting through help functions and usage examples.

## Gotchas

- `px` requires zsh and must be sourced, not executed
- Git scripts require gum for interactive workflows
- `k` script requires fzf, kubectl, and jq
- Configuration files are sourced from `~/.local/etc/` not local `/etc/`
- Some scripts (like aifortune) may require API keys in config files
- Docker-dependent scripts need running Docker daemon