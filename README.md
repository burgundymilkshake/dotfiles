# dotfiles

My dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory is a stow *package* that mirrors `$HOME`; stowing a
package symlinks its files into place.

## Setup on a new machine (Linux or macOS)

```bash
git clone <your-remote> ~/dotfiles
cd ~/dotfiles
./install.sh          # installs stow if needed, then stows everything
```

Or stow packages selectively:

```bash
cd ~/dotfiles
stow -t ~ zsh git     # just zsh and git configs
```

If a real file already exists at a target path, stow refuses to overwrite it.
Either delete/back up the file, or run `stow --adopt -t ~ <pkg>` to pull the
existing file into the repo (then review with `git diff`).

## Packages

| Package | Files |
|---------|-------|
| `zsh`   | `.zshrc` |
| `bash`  | `.bashrc`, `.bash_profile`, `.bash_logout`, `.profile` |
| `git`   | `.gitconfig`, `.gitignore` |
| `fzf`   | `.fzf.zsh`, `.fzf.bash` |
| `mcp`   | `.mcp.json` |
| `nvim`  | `.config/nvim/` (init.lua, lazy.nvim plugins, lua modules) |
| `tmux`  | `.config/tmux/tmux.conf` |

## Adding a new dotfile

```bash
mkdir -p ~/dotfiles/<pkg>            # mirror $HOME structure inside the package
mv ~/.somerc ~/dotfiles/<pkg>/.somerc
cd ~/dotfiles && stow -t ~ <pkg>
git add <pkg> && git commit -m "Add somerc"
```

For files under `~/.config`, mirror the path, e.g.
`~/dotfiles/nvim/.config/nvim/init.lua`.

## Never commit secrets

Keep credentials out of this repo: `.env`, `.npmrc`, `~/.ssh`, `~/.aws`,
`~/.azure`, `~/.kube`, `~/.docker`, `~/.gnupg`, shell histories. The
`.stow-local-ignore`-style guard here is the repo `.gitignore`.
