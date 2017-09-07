# dotfiles


```bash
git clone --bare git@github.com:randy3k/dotfiles.git $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local alias.github '!git add -u && git commit -m "Update dotfiles at $(date)" && git push'
dotfiles reset --hard

rm ~/README.md
dotfiles update-index --skip-worktree README.md
```

Credit: inspired by https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
