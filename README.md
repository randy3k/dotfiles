# dotfiles


```bash
git clone --bare git@github.com:randy3k/dotfiles.git $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local alias.github '!git add -u && git commit -m "Update dotfiles at $(date)" && git push'
dotfiles reset --hard

echo "~/README.md" >> ~/.dotfiles/info/exclude
rm ~/README.md
dotfiles update-index --assume-unchanged README.md 
```
