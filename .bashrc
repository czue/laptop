# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

HISTTIMEFORMAT='%F %T '

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# virtualenvwrapper setup
export VIRTUALENVWRAPPER_PYTHON=$HOME/.virtualenvs/virtualenvwrapper/bin/python
export WORKON_HOME=$HOME/.virtualenvs
# export VIRTUALENVWRAPPER_VIRTUALENV=/home/czue/.local/bin/virtualenv
source $HOME/.virtualenvs/virtualenvwrapper/bin/virtualenvwrapper.sh

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# git aliases
alias list-branches='for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r'
alias branch="git branch | grep '^\*' | sed 's/* //'"

# custom functions
function delete-pyc() {
    find . -name '*.pyc' -delete
}
function pull-latest-master() {
    git checkout master; git pull origin master
    git submodule update --init
    git submodule foreach --recursive 'git checkout master; git pull origin master &'
    until [ -z "$(ps aux | grep '[g]it pull')" ]; do sleep 1; done
}

function pull-latest-develop() {
    git checkout develop; git pull origin develop
}

function pull-latest-main() {
    git checkout main; git pull origin main
}

function pull-code() {
    pull-latest-master
    delete-pyc
}

function pull-code-develop() {
    pull-latest-develop
    delete-pyc
}

function pull-code-main() {
    pull-latest-main
    delete-pyc
}

function delete-squashed-merged-branches() {
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    if [ "$current_branch" != "main" ]; then
        echo "❌ You are not on branch main (current: $current_branch)"
        return 1
    fi

    # Loop through all local branches except main
    for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/ | grep -v '^main$'); do
        # Check whether the branch's changes already exist in main
        if git diff --quiet main.."$branch"; then
            echo "🧹 Deleting merged/squash-merged branch: $branch"
            git branch -d "$branch"
        else
            echo "⚠️  Keeping branch (not merged): $branch"
        fi
    done
}

function delete-merged-branches() {
    if [ $(branch) = 'master' ]
        then git branch --merged master | grep -v '\*' | xargs -n1 git branch -d
        else echo "You are not on branch master"
    fi
}

function delete-merged-branches-develop() {
    if [ $(branch) = 'develop' ]
        then git branch --merged develop | grep -v '\*' | xargs -n1 git branch -d
        else echo "You are not on branch develop"
    fi
}

function delete-merged-branches-main() {
    if [ $(branch) = 'main' ]
        then git branch --merged main | grep -v '\*' | grep -v 'pegasus' | xargs -n1 git branch -d
        else echo "You are not on branch main"
    fi
}

# Video helpers
if [ -f ~/.bash_video ]; then
    . ~/.bash_video
fi

# path updates
export PATH=$PATH:/home/czue/bin/

# config
export EDITOR=emacs

# fly.io
export FLYCTL_INSTALL="/home/czue/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# https://askubuntu.com/a/80380/65046
export PROMPT_COMMAND='history -a'

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
export ATUIN_NOBIND="true"
eval "$(atuin init bash)"

# bind to ctrl-r, add any other bindings you want here too
bind -x '"\C-r": __atuin_history'
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


# Peregrine
if [ -f ~/.bash_peregrine ]; then
    . ~/.bash_peregrine
fi

. "$HOME/.cargo/env"

# add Pulumi to the PATH
export PATH=$PATH:/home/czue/.pulumi/bin

# add pegasus tools to the PATH
export PATH=$PATH:/home/czue/src/personal/pegasus/tools/bin


# Claude setup
if [ -f ~/.bash_claude ]; then
    . ~/.bash_claude
fi
