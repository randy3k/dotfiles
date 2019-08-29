# dotfiles


```bash
git clone --bare git@github.com:randy3k/dotfiles.git $HOME/.dotfiles
alias dgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dgit config --local status.showUntrackedFiles no
dgit config --local alias.save '!git add -u && git commit -m "Update dotfiles at $(date -u)" && git push'
dgit config --local pull.rebase true
dgit reset --hard

rm ~/README.md
dgit update-index --skip-worktree README.md
```

Credit: inspired by https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
