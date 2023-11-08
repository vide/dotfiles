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
HISTSIZE=1000000
HISTFILESIZE=2000000
export HISTTIMEFORMAT='%F %T '
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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@shadow\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

export EDITOR=vim
export VISUAL=vim

[[ $- != *i* ]] && return
[[ -z "$TMUX" ]] && tmux

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

# autocorrect typos
shopt -s cdspell

PATH=$HOME/.krew/bin:~/.local/bin:~/bin:$PATH
GIT_PROMPT_ONLY_IN_REPO=1
source ~/.bash-git-prompt/gitprompt.sh

source <(kubectl completion bash)
#source $HOME/git/infrastructure/scripts/hashienv/hashienv.sh
eval "$(direnv hook bash)"

export KUBECONFIG=/home/vide/.stuart_kubeconfig.yaml
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

function tfa {
	terraform apply "$@"
        RET=$?
	notify-send --urgency=low -i "$([ $RET = 0 ] && echo terminal || echo error)" "terraform apply" "finished with $([ $RET = 0 ] && echo success || echo error)"

}

function tfd {
	terraform destroy "$@"
    RET=$?
	notify-send --urgency=low -i "$([ $RET = 0 ] && echo terminal || echo error)" "terraform destroy" "finished with $([ $RET = 0 ] && echo success || echo error)"
}

function tfp {
	terraform plan "$@"
    RET=$?
	notify-send --urgency=low -i "$([ $RET = 0 ] && echo terminal || echo error)" "terraform plan" "finished with $([ $RET = 0 ] && echo success || echo error)"
}

function rgp {
    rg -n "$@" | fpp
}

function tfpfile {
  [ -z $1 ] && { echo "No input file provided"; return; }
  TARGETS="$(grep -Eo "(module|resource) (\".*\")( \".*\")?" "$1"|sed 's/resource //g;s/"//g;s/ /./g;s/^/-target=/g'|tr '\n' ' ')"
  echo "Running tfp $TARGETS"
  tfp $TARGETS
}

function tfafile {
  [ -z $1 ] && { echo "No input file provided"; return; }
  TARGETS="$(grep -Eo "(module|resource) (\".*\")( \".*\")?" "$1"|sed 's/resource //g;s/"//g;s/ /./g;s/^/-target=/g'|tr '\n' ' ')"
  echo "Running tfa $TARGETS"
  tfa $TARGETS
}

function tfdfile {
  [ -z $1 ] && { echo "No input file provided"; return; }
  TARGETS="$(grep -Eo "(module|resource) (\".*\")( \".*\")?" "$1"|sed 's/resource //g;s/"//g;s/ /./g;s/^/-target=/g'|tr '\n' ' ')"
  echo "Running tfa $TARGETS"
  tfd $TARGETS
}

complete -W "$(grep '\[profile' ~/.aws/config | tr -d '[]' | awk '{print $2}')" aws-profile

function aws-profile() {
  if [[ -z "${1}" ]]; then
    profiles=$(grep '\[profile' ~/.aws/config | tr -d '[]' | awk '{print $2}')
    for profile in $profiles; do
      if [[ "${profile}" == "${AWS_PROFILE}" ]]; then
        echo "${profile} *"
      else
        echo "${profile}"
      fi
    done
  else
    export AWS_PROFILE="${1}"
  fi
}

alias tfi='terraform init'
alias ag='rg'
alias agp='rgp'
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
alias cdt='cd $HOME/git/infrastructure/terraform/v3'
alias cda='cd $HOME/git/infrastructure/ansible'
alias cds='cd $HOME/git/sre/sre'
alias ssm='aws ssm start-session --target'
alias ssoprod='aws-profile stuart-aws-prod && aws sso login'
source <(gh completion -s bash)

export PATH=$HOME/bin:$PATH

source /usr/share/doc/fzf/examples/key-bindings.bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
