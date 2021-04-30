# dotfiles


```bash
git clone --bare git@github.com:randy3k/dotfiles.git $HOME/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot config --local status.showUntrackedFiles no
dot config --local pull.rebase true
dot reset --hard

rm ~/README.md
dot update-index --skip-worktree README.md
```

Credit: inspired by https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
