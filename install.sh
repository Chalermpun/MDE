# WARNING: Ubuntu 24.04

apt update
apt install curl wget unzip  git checkinstall sudo -y

# NOTE: neovim v0.10.2
apt install ninja-build gettext cmake unzip curl build-essential libgit2-1.7 -y
git clone https://github.com/neovim/neovim && cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install

#NOTE: chafa
git clone https://github.com/hpjansson/chafa.git
apt install autoconf automake libtool pkg-config libglib2.0-dev libfreetype-dev -y
cd chafa
./autogen.sh
make
make install
ldconfig

#NOTE: ueberzugpp
apt install --fix-broken -y
wget https://ftp.gwdg.de/pub/opensuse/repositories/home%3A/justkidding/xUbuntu_24.04/amd64/ueberzugpp_2.9.6_amd64.deb
dpkg -i ueberzugpp_2.9.6_amd64.deb
apt install --fix-broken -y
dpkg -i ueberzugpp_2.9.6_amd64.deb

#NOTE: imagemagick
wget https://imagemagick.org/archive/ImageMagick.tar.gz
tar -xf ImageMagick.tar.gz
cd ImageMagick-7.1.1-41/
./configure
make
make install
ldconfig /usr/local/lib


#NOTE: ZSH
apt install zsh bat tree -y
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search
sed 's/^plugins=(git/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-fzf-history-search/g' ~/.zshrc >~/zshrc.txt
mv ~/zshrc.txt ~/.zshrc

cat <<'EOF' >> ~/.zshrc
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    nvim)         fzf "$@" --preview 'bat --style=numbers --color=always {}' ;;
    *)            fzf "$@" ;;
  esac
}
EOF

#NOTE: yazi v0.3.3
apt install file ffmpegthumbnailer p7zip-full jq  ripgrep zoxide -y
wget https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-musl_10.2.0_amd64.deb
dpkg -i fd-musl_10.2.0_amd64.deb
wget https://github.com/sxyazi/yazi/releases/download/v0.3.3/yazi-x86_64-unknown-linux-musl.zip
unzip yazi-x86_64-unknown-linux-musl.zip
cd yazi-x86_64-unknown-linux-musl
mv yazi /bin/
CONFIG_FILE="$HOME/.config/yazi/yazi.toml"
CONTENT="[opener]
edit = [{ run = 'nvim \"\$@\"', block = true }]"
mkdir -p "$(dirname "$CONFIG_FILE")"
echo "$CONTENT" > "$CONFIG_FILE"

# NOTE: install lsd
wget https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd-musl_1.1.5_amd64.deb
dpkg -i lsd-musl_1.1.5_amd64.deb
echo 'alias ls="lsd"' >>~/.zshrc


#NOTE: lazy.nvim
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
apt install lua5.3 liblua5.3-dev -y
apt install lua5.1 liblua5.1-dev -y
./configure && make && make install
luarocks install luasocket


#NOTE: npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source .zshrc
nvm install v23.3.0
npm install --global yarn


#NOTE: neovim setup
git clone --single-branch --branch simple git@github.com:Chalermpun/PDE.git ~/.config/nvim


#NOTE: tmux setup
apt install tmux -y
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp ~/.config/nvim/.tmux.conf ~/
echo 'alias tmux="tmux -u"' >>~/.zshrc


#NOTE: VISDATA
apt install python3 python3-venv python3-pip -y
pip3 install visdata --break-system-packages

#NOTE: Install Font
mkdir ~/.local/share/fonts
cd && cd .local/share/fonts
curl -fLo font.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
unzip font.zip
fc-cache -fv

#NOTE: Bottom
curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
sudo dpkg -i bottom_0.9.6_amd64.deb

#NOTE: codium
# https://codeium.com/vim-show-auth-token?response_type=token&redirect_uri=vim-show-auth-token&state=a&scope=openid+profile+email&redirect_parameters_type=query

#NOTE: nvitop
pip3 install --upgrade nvitop


#NOTE: aerospace
echo 'ff () {
    aerospace list-windows --all | fzf --bind '"'"'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'"'"'
}' >> ~/.zshrc
