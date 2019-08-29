# dotfiles


```bash
git clone --bare git@github.com:randy3k/dotfiles.git $HOME/.dotfiles
alias dotgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotgit config --local status.showUntrackedFiles no
dotgit config --local pull.rebase true
dotgit reset --hard

rm ~/README.md
dotgit update-index --skip-worktree README.md
```

Credit: inspired by https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
