vim-setup:
	sudo apt install -y curl vim
	sudo apt remove -y nano
	ln -s ~/git/personal/dotfiles/.vim ~/.vim
	ln -s ~/git/personal/dotfiles/.vimrc ~/.vimrc
	mkdir -p ~/.vim/autoload
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
