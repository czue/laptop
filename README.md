# Cory's Laptop Files

Some stuff I wanted to transfer across after my laptop died...

## Initialization

To use the global .gitignore file run:

```
git config --global core.excludesFile '~/.gitignore_global'
```

## Bash Configuration

The `.bashrc` sources modular config files for different tools/projects:
- `.bash_peregrine` - Peregrine project settings
- `.bash_claude` - Claude CLI profile functions
- `.bash_video` - Video processing helpers

**Note:** Replace `YOUR_GITHUB_TOKEN_HERE` in `.bash_peregrine` with your actual GitHub token.

### Syncing dotfiles

To copy dotfiles from this repo to your home directory:

```
./scripts/sync-dotfiles.sh
```

To copy dotfiles from your home directory back to this repo (after making changes):

```
./scripts/sync-dotfiles.sh --from-home
```

After syncing to home, reload your bash configuration with:

```
source ~/.bashrc
```