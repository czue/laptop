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

### Project Switching

The `.bashrc` also sources `.bash_devon` for project switching via [dev-on](https://github.com/czue/dev-on), a standalone Rust CLI tool. Install separately:

```bash
cargo install --path ~/src/personal/dev-on
# Then source the bash wrapper from the dev-on repo
```

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