pkg update && pkg upgrade -y
pkg install tur-repo -y
pkg install python-pandas -y
pkg install libsixel -y
pkg install imagemagick -y
pkg install bat -y
pkg install tree -y
pkg install ninja automake cmake binutils patchelf git -y
apt-get install gettext cmake unzip curl -y
pkg install matplotlib -y
git clone https://github.com/neovim/neovim
cd neovim
rm -r build/  # clear the CMake cache
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
make install
export PATH="$HOME/neovim/bin:$PATH"
cp ~/neovim/bin/nvim /data/data/com.termux/files/usr/bin
pkg install lsd -y
cd && cd .termux && curl -fLo font.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip  && mkdir fonts && mv font.zip fonts &&  cd fonts && unzip font.zip && mv "FiraCodeNerdFont-Regular.ttf" .. && cd .. && mv "FiraCodeNerdFont-Regular.ttf" font.ttf && rm -rf fonts
echo alias ls=lsd >> /data/data/com.termux/files/usr/etc/bash.bashrc
termux-reload-settings
pkg install nodejs -y
pkg install fd ripgrep openssh -y
pkg install tmux -y
pkg install zsh -y
ssh-keygen -t ed25519 -C "chalermpun.mo@gmail.com"
cat ~/.ssh/id_ed25519.pub

cd && mkdir -p .config/ && cd .config
git clone git@github.com:Chalermpun/PDE.git


cd PDE
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp .tmux.conf ~/
git switch lazy
cd .. && cp -r PDE nvim

#close and open
chsh -s zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search

# Update the Zsh configuration file (.zshrc) with the new plugins
sed 's/^plugins=(git/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-fzf-history-search/g' ~/.zshrc >~/zshrc.txt
mv ~/zshrc.txt ~/.zshrc
pip3 install pynvim --upgrade 


echo '
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    nvim)         fzf "$@" --preview 'bat --style=numbers --color=always {}' ;;
    *)            fzf "$@" ;;
  esac
}
' >> ~/.zshrc
