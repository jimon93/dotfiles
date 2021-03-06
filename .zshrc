## Language setting
export LANG=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export LANG=ja_JP.UTF-8
#export LC_ALL=ja_JP.UTF-8
export PAGER=less
export EDITOR=vim

## PATH
export PATH=${HOME}/bin:/usr/local/bin:${PATH}:/usr/local/sbin:/usr/local/share/npm/bin

# Export path for nodebrew
if [[ -f ~/.nodebrew/nodebrew ]]; then
  export PATH=$HOME/.nodebrew/current/bin:$PATH
  nodebrew use latest > /dev/null
fi

# rbenv
export PATH=$HOME/.rbenv/shims:$PATH
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# scala version manager
export SCALA_HOME=~/.svm/current/rt
export PATH=$SCALA_HOME/bin:$PATH

# chef
export PATH=$PATH:/opt/chef/bin

## Default shell configuration set prompt
autoload colors
colors
case ${UID} in
#root
0)
  PROMPT="%B%{${fg[green]}%}#%{${reset_color}%}%b "
  PROMPT2="%B%{${fg[green]}%}#%{${reset_color}%}%b "
  RPROMPT="[%~]"
  SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  #[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT="[%{${fg[white]}%}${USER}]${PROMPT}"
;;
#user
*)
  PROMPT="%{${fg[green]}%}%%%{${reset_color}%} "
  PROMPT2="%{${fg[green]}%}%%%{${reset_color}%} "
  RPROMPT="[%~]"
  SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
  #[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT="[%{${fg[white]}%}${USER}]${PROMPT}"
;;
esac

## auto change directory
setopt auto_cd

## auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd

## command correct edition before each completion attempt
setopt correct

## compacked complete list display
setopt list_packed

## no remove postfix slash of command line
setopt noautoremoveslash

## no beep sound when complete list displayed
setopt nolistbeep

## Keybind configuration
bindkey -e

## historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

## Command history configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data

## Completion configuration
autoload -U compinit
compinit

# Enter -> ls & git status
function do_enter(){
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    ls
    # ↓おすすめ
    # ls_abbrev
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^m' do_enter

## Alias configuration
setopt complete_aliases # aliased ls needs if file/dir completions work
alias where="command -v"
alias j="jobs -l"
case "${OSTYPE}" in
freebsd*|darwin*)
  alias ls="ls -G -w -F"
  #export PATH=/opt/local/bin:/opt/local/sbin:${PATH}
  ;;
linux*)
  alias ls="ls -a --color"
  ;;
esac
alias ll="ls -al"
alias du="du -h"
alias df="df -h"
alias su="su -l"
alias screen="export SCREEN=YES ; screen -U -T ${TERM}"
alias emacs '/usr/local/bin/emcws -l ~/.emacs'
alias g++='g++ -O2 -std=c++11'
alias oj="python ~/github/OnlineJudgeHelper/oj.py --setting='~/.OJH-setting.json'"

#rlwrap
#export RLWRAP_EDITOR='vim -c "set filetype=scheme'
#alias gosh=rlwrap -c -q '"' -b "'"'(){}[].,#@;|`' -m gosh "$@"
## terminal configuration
unset LSCOLORS
case "${TERM}" in
xterm)
  export TERM=xterm
  ;;
xterm-color)
  export TERM=xterm-color
  ;;
xterm-256color)
  export TERM=xterm-256color
  ;;
kterm)
  export TERM=kterm-color
  # set BackSpace control character
  stty erase
  ;;
cons25)
  unset LANG
  export LSCOLORS=ExFxCxdxBxegedabagacad
  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
  ;;
esac

## set terminal title including current directory
case "${TERM}" in
kterm*|xterm*)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
  }
  export LSCOLORS=exfxcxdxbxegedabagacad
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
   ;;
esac

if [ "$SCREEN" = "YES" ]; then
  chpwd () { echo -n "_`dirs`\\" }
  preexec() {
    # see [zsh-workers:13180]
    # http://www.zsh.org/mla/workers/2000/msg03993.html
    emulate -L zsh
    local -a cmd; cmd=(${(z)2})
    case $cmd[1] in
      fg)
        if (( $#cmd == 1 )); then
          cmd=(builtin jobs -l %+)
        else
          cmd=(builtin jobs -l $cmd[2])
        fi
        ;;
      %*)
        cmd=(builtin jobs -l $cmd[1])
        ;;
      cd)
        if (( $#cmd == 2)); then
          cmd[1]=$cmd[2]
        fi
        ;&
      *)
        echo -n "k$USER@$cmd[1]:t\\"
        return
        ;;
    esac

    local -A jt; jt=(${(kv)jobtexts})

    $cmd >>(read num rest
      cmd=(${(z)${(e):-\$jt$num}})
      echo -n "k$cmd[1]:t\\") 2>/dev/null
  }
  chpwd
fi

#if [ -n ${WINDOW} ]; then
#  precmd() {
#    screen -X title "$USER@${PWD/~HOME/~}"
#  }
#  preexec() {
#    screen -X title "$USER@${PWD/~HOME/~}"
#  }
#fi

## load user .zshrc configuration file
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

# This loads NVM
[ -f "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# sbtとかmavenのビルドを早くする
export JAVA_OPTS="$JAVA_OPTS -Dhttp.proxyHost=leica -Dhttp.proxyPort=8080"
export SBT_OPTS="-XX:+HeapDumpOnOutOfMemoryError -server -XX:ReservedCodeCacheSize=2g -Xmx4g -Xss4M -XX:MaxPermSize=2024M -XX:+DoEscapeAnalysis -XX:+UseCompressedOops -XX:+CMSClassUnloadingEnabled -XX:+UseCodeCacheFlushing"
