#!/bin/sh
# Author: Abhishek Anand Amralkar
# Shell (zsh) and syntax highlighting

unset CDPATH
#CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ZSH_BIN=${ZSH_BIN:-"/usr/bin/zsh"}

install_zsh () {
    if [  -e "$ZSH_BIN" ];
    then
      sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
      git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
      git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
      ./setup-fzf.sh
      git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
      sudo rm -rf ~/.zshrc
      cd /tmp && wget https://raw.githubusercontent.com/abhishekamralkar/configs/master/ohmyzsh/zshrc
      mv /tmp/zshrc ~/.zshrc
      sudo chsh -s /bin/zsh

    else
      echo "oh-my-zsh is installed ..."
    fi
}

main () {
    install_zsh
}

main
