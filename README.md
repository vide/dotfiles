## My personal .dotfiles

This repo collects my personal dotfiles, centered in console productivity.
The makefile to help with installation is thought with Ubuntu Linux in mind but the config files themselves will work with any other unix-like operating system.

Right now this repo includes:
- tmux customizations
- Vim customizations

If you find it useful, feel free to clone/fork it and share your suggestions!

### How to check this repo out

I use git submodules to link to other projects ([Oh-my-tmux](https://github.com/gpakosz/.tmux) and various vim plugins) so it's better if you check it out like this:

```bash
git clone --recurse-submodules https://github.com/vide/dotfiles.git
```

in your preferred directory.

*WARNING*: you should export the absolute path of the repo directory so the make instruction can succeed in a variable called `$REPO`.

### Powerline fonts installation

```bash
cd $REPO
make powerline
```

### Vim installation

```bash
cd $REPO
make vim-setup
```

### Tmux installation

```bash
cd $REPO
make tmux-setup
```
