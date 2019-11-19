REPO?=~/git/personal/dotfiles
vim-setup:
	sudo apt install -y curl vim
	sudo apt remove -y nano
	ln -sf $(REPO)/.vim ~/.vim
	ln -sf $(REPO)/.vimrc ~/.vimrc
	mkdir -p ~/.vim/autoload
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
powerline:
	git clone https://github.com/powerline/fonts.git --depth=1 /tmp/fonts
	/tmp/fonts/install.sh
	rm -rf /tmp/fonts
tmux-setup:
	ln -sf $(REPO)/.tmux/.tmux.conf ~/.tmux.conf
	ln -sf $(REPO)/.tmux.conf.local ~/.tmux.conf.local
git-setup:
	ln -sf $(REPO)/gitconfig ~/.gitconfig
bash-setup:
	git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
	ln -sf $(REPO)/.bashrc ~/.bashrc
