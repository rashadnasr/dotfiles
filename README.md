# DotFiles 🛠️
The collection of dotfiles and various config files and scripts for my linux install

## Installation

1. Clone this repository:

```bash
git clone git@github.com:rashadnasr/dotfiles.git "$HOME"/.dotfiles
```
2. Make sure stow is installed:

### Arch linux
```bash
sudo pacman -S stow
```
3. Use stow to install the config files:
```bash
stow "$HOME"/.dotfiles --adopt
