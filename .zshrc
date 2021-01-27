# Created by newuser for 5.0.5
# Lines configured by zsh-newuser-install
HISTFILE=${HOME}/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory autocd extendedglob nonomatch
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/sashimi/.zshrc'

# zsh-completions
source ${HOME}/.zsh/zsh-completions/zsh-completions.plugin.zsh

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Alias definitions
# You may want to put all your additions into a separate file like
# ~/.zsh_aliases, instead of adding them here directly.
if [ -f ${HOME}/.zsh_aliases ]; then
    . ${HOME}/.zsh_aliases
fi

# language
export LANG=en_US.UTF-8

# prompt
autoload -Uz colors
colors

if [ ${UID} -eq 0 ] ; then
    PROMPT="
%{${fg[magenta]}%}%n@%m: %{${fg[green]}%}%~%{${reset_color}%}
%# "
elif [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] ; then
    PROMPT="
%{${fg[yellow]}%}%n@${HOST%%.*}: %{${fg[green]}%}%~%{${reset_color}%}
%# "
else
    PROMPT="
%{${fg[cyan]}%}%n@%m: %{${fg[green]}%}%~%{${reset_color}%}
%# "
fi

#RPROMPT="%{${fg[yellow]}%}[%W %T]%{${reset_color}%}"
PROMPT2="%_%%"
SPROMPT="zsh: correct '%R' -> '%r'? [n/y/a/e]: "

# less highlight
if [ -f /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
    export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
fi

export XDVIINPUTS=/etc/texmf/xdvi

export R_HOME=/usr/lib/R
export EDITOR=vim

# display terminal title "username@hostname:~currentDir"
case "${TERM}" in
kterm*|xterm|lxterm*|xfce4-term*)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

# command history
setopt histignoredups sharehistory
setopt hist_ignore_all_dups hist_save_nodups
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^R" history-incremental-pattern-search-backward

# utility
setopt autopushd correct listpacked pushd_ignore_dups auto_param_keys
function chpwd() { ls }

# disable auto remove slash(/)
setopt noautoremoveslash

# ignore case completion
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=1

# colored completion
zstyle ':completion:*' list-colors 'di=01;34' 'ln=01;36' 'ex=01;32'

# syntax highlight
[[ -f $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# do not show message "do you wish to see all ..."
LISTMAX=0

# for Em
export VTE_CJK_WIDTH=1

# Git
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' max-exports 6
zstyle ':vcs_info:*' actionformats '%b %r %a' '%c' '%u'
zstyle ':vcs_info:*' formats '%b %r' '%c' '%u'

vcs_info_wrapper() {
    vcs_info
    if [ -n "${vcs_info_msg_0_}" ]; then
        br=`echo "${vcs_info_msg_0_}" | sed -e "s/^\(\S\+\) \S\+\( \S\+\)\?$/\1/"`
        re=`echo "${vcs_info_msg_0_}" | sed -e "s/^\S\+ \(\S\+\)\( \S\+\)\?$/\1/"`
        ac=`echo "${vcs_info_msg_0_}" | sed -e "s/^\S\+ \S\+ \(\w\+\)$/\1/"`
        [ ${ac} != ${vcs_info_msg_0_} ] && re="${re} ${ac}"

        branch="%{$reset_color%}[%{${fg[green]}%}${br}%{$reset_color%}@%{${fg[cyan]}%}${re}%{$reset_color%}]"
        if [[ -n `git status 2>/dev/null | grep "^Untracked"` ]]; then
            # untracked
            echo "%{${fg[magenta]}%}(untracked) ${branch}%{$reset_color%}"
        elif [ -n "$vcs_info_msg_2_" ]; then
            # unstaged
            echo "%{${fg[yellow]}%}(unstaged) ${branch}%{$reset_color%}"
        elif [ -n "$vcs_info_msg_1_" ]; then
            # staged
            echo "%{${fg[green]}%}(staged) ${branch}%{$reset_color%}"
        else
            # clean
            echo "%{${fg[cyan]}%}${branch}%{$reset_color%}"
        fi
    fi
}
RPROMPT=$'$(vcs_info_wrapper)'

# auto-fu.zsh
if [ -d "$HOME/.zsh" ]; then
    if [ -d "$HOME/.zsh/auto-fu.zsh" ]; then
        source "$HOME/.zsh/auto-fu.zsh/auto-fu.zsh"
        function zle-line-init ()
        {
            auto-fu-init
        }
        zle -N zle-line-init
        zstyle ':completion:*' completer _oldlist _complete
    fi
fi
# 補完候補を矢印キーなどで選択出来るようにする。
zstyle ':completion:*:default' menu select
# delete unambiguous prefix when accepting line
function afu+delete-unambiguous-prefix () {
    afu-clearing-maybe
    local buf; buf="$BUFFER"
    local bufc; bufc="$buffer_cur"
    [[ -z "$cursor_new" ]] && cursor_new=-1
    [[ "$buf[$cursor_new]" == ' ' ]] && return
    [[ "$buf[$cursor_new]" == '/' ]] && return
    ((afu_in_p == 1)) && [[ "$buf" != "$bufc" ]] && {
        # there are more than one completion candidates
        zle afu+complete-word
        [[ "$buf" == "$BUFFER" ]] && {
            # the completion suffix was an unambiguous prefix
            afu_in_p=0; buf="$bufc"
        }
        BUFFER="$buf"
        buffer_cur="$bufc"
    }
}
zle -N afu+delete-unambiguous-prefix
function afu-ad-delete-unambiguous-prefix () {
    local afufun="$1"
    local code; code=$functions[$afufun]
    eval "function $afufun () { zle afu+delete-unambiguous-prefix; $code }"
}
afu-ad-delete-unambiguous-prefix afu+accept-line
afu-ad-delete-unambiguous-prefix afu+accept-line-and-down-history
afu-ad-delete-unambiguous-prefix afu+accept-and-hold

# zsh-dwim
# C-@で次に入力するコマンドを推測する
bindkey -r "^u"
source ${HOME}/.zsh/zsh-dwim/init.zsh

## Load zsh-autosuggestions.
#source ~/.zsh/zsh-autosuggestions/autosuggestions.zsh
## Enable autosuggestions automatically.
#zle-line-init() {
#    zle autosuggest-start
#}
#zle -N zle-line-init
## use ctrl+f to accept a suggested word
#bindkey "^F" autosuggest-execute-suggestion

# show net-tools deprecated message
net_tools_deprecated_message () {
  echo -n 'net-tools コマンドはもう非推奨ですよ？おじさんなんじゃないですか？ '
}
arp () {
  net_tools_deprecated_message
  echo 'Use `ip n`'
}
ifconfig () {
  net_tools_deprecated_message
  echo 'Use `ip a`, `ip link`, `ip -s link`'
}
iptunnel () {
  net_tools_deprecated_message
  echo 'Use `ip tunnel`'
}
iwconfig () {
  echo -n 'iwconfig コマンドはもう非推奨ですよ？おじさんなんじゃないですか？ '
  echo 'Use `iw`'
}
nameif () {
  net_tools_deprecated_message
  echo 'Use `ip link`, `ifrename`'
}
netstat () {
  net_tools_deprecated_message
  echo 'Use `ss`, `ip route` (for netstat -r), `ip -s link` (for netstat -i), `ip maddr` (for netstat -g)'
}
route () {
  net_tools_deprecated_message
  echo 'Use `ip r`'
}

# RSense
#export RSENCE_HOME="/usr/local/lib/rsense-0.3"

# thefuck
#eval $(thefuck --alias)

# English <-> Japanese dictionary
function ejdict() {
    grep "$*" /usr/share/dict/gene -E -A 1 -wi --color=always | less -R -FX
}

function jedict() {
    grep "$*" /usr/share/dict/gene -E -B 1 -wi --color=always | less -R -FX
}

# Command line tools for Google Translation
source ${HOME}/.zsh/translate-shell/translate-shell.plugin.zsh

# Enable C-s shortcut key
stty stop undef

# Enable git flow command completion
source ${HOME}/.zsh/git-flow-completion/git-flow-completion.zsh

# rbenv
which rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

# z
[ -f "/usr/share/z/z.sh" ] && . "/usr/share/z/z.sh"

# local settings
# you MUST load .zsh_local at the end of this script
[ -f "$HOME/.zsh_local" ] && . "$HOME/.zsh_local"
