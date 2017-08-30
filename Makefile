files = .aliases .bashrc .bash_profile .profile .zshrc \
		.zprofile .Rprofile .nvimrc .gitconfig .gitlocal .tmux.conf .screenrc

all: backup
	git add -A \
	&& git commit -m "Update dotfiles at $$(date)" \
	&& git push

backup:
	for f in $(files); do echo $$f; rm -r ./$$f 2>/dev/null; cp -r ~/$$f ./$$f; done

restore:
	for f in $(files); do echo $$f; rm -r ~/$$f 2>/dev/null; cp -r ./$$f ~/$$f; done
