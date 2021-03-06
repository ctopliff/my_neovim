#!/bin/bash -e

# Installs Optixal's neovim-init.vim into ~/.config/nvim/init.vim. Intended for Ubuntu/Debian. I highly recommend running the following commands manually, especially if you are running macOS or other Linux distros. For macOS, use homebrew instead of apt.

# Make config directory for Neovim's init.vim
echo '[*] Preparing Neovim config directory ...'
mkdir -p ~/.config/nvim

BASH_SHELL_CONFIG=~/.bash_profile
ZSH_SHELL_CONFIG=~/.zshrc

# Install virtualenv to containerize dependencies for vim-pydocstring (doq) and pep8-style formatting feature (yapf)
echo '[*] Installing Python dependencies in a virtual environment ...'
python3 -m venv ~/.config/nvim/env
source ~/.config/nvim/env/bin/activate
pip install wheel
pip install yapf doq
deactivate

# Install vim-plug plugin manager
echo '[*] Downloading vim-plug, the best minimalistic vim plugin manager ...'
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create a backup of your current init.vim if you have one
if [ -f ~/.config/nvim/init.vim ]; then
    echo '[*] Backing up existing init.vim'
    cp ~/.config/nvim/init.vim ~/.config/nvim/init.vim.backup
fi

# Enter Neovim and install plugins with vim-plug's :PlugInstall and coc extensions with CoC's :CocInstall using a temporary init.vim, which avoids warnings about missing colorschemes, functions, etc
echo -e '[*] Running :PlugInstall within nvim ...'
sed '/call plug#end/q' init.vim > ~/.config/nvim/init.vim
nvim -c 'PlugInstall' -c 'qa'
rm ~/.config/nvim/init.vim

# Copy init.vim in current working directory to nvim's config location
echo '[*] Copying init.vim -> ~/.config/nvim/init.vim'
cp init.vim ~/.config/nvim/

echo -e "[+] Done, welcome to your new \033[1m\033[92mNeovim\033[0m experience! Try it by running: nvim. Want to customize it? Modify ~/.config/nvim/init.vim! Remember to change your terminal font to Iosevka Term Nerd Font, or any other preferred nerd font :)"
