# git aliases from Adam Johnson

alias g='git'
alias gg='git gui'
alias gl='git pull'
alias gp='git push'
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcn='git commit --no-verify'
alias gb='git branch'
alias grb='git rebase'
alias ga='git add'
alias grh='git reset HEAD'


# Docker Compose aliases for local database development
alias dbup='cd /home/czue/src/personal/services && docker compose up -d && cd -'
alias dbdown='cd /home/czue/src/personal/services && docker compose down && cd -'

alias dcd='docker compose down'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
