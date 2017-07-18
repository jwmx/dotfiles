#
# zplug
#

source ~/.zplug/init.zsh

zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-syntax-highlighting', defer:3
zplug 'mollifier/anyframe'

if ! zplug check --verbose; then
  printf 'Install? [y/N]'
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose

#
# autoloads
#

autoload -Uz add-zsh-hook
autoload -Uz compinit && compinit -u
autoload -Uz url-quote-magic
autoload -Uz vcs_info

#
# ZLE
#

zle -N self-insert url-quote-magic

#
# General
#

setopt auto_list
setopt auto_menu
setopt auto_pushd
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt share_history
setopt ignore_eof
setopt inc_append_history
setopt interactive_comments
setopt no_beep
setopt no_hist_beep
setopt no_list_beep
setopt magic_equal_subst
setopt notify
setopt print_eight_bit
setopt print_exit_value
setopt prompt_subst
setopt pushd_ignore_dups
setopt rm_star_wait
setopt transient_rprompt

#
# Exports
#

export CLICOLOR=true
export LSCOLORS='exfxcxdxbxGxDxabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
export EDITOR=vim
export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000000
export LANG=ja_JP.UTF-8

#
# Key bindings
#

bindkey -v
bindkey -v '^?' backward-delete-char
bindkey '^[[Z' reverse-menu-complete
bindkey '^@' anyframe-widget-cd-ghq-repository
bindkey '^r' anyframe-widget-put-history

#bindkey '^P' history-beginning-search-backward   #
#bindkey '^N' history-beginning-search-forward
#bindkey '^R' history-imcremental-search-backward
#bindkey '^S' history-imcremental-search-forward

#
# Aliases
#

alias vi='vim'
alias ll='ls -al'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias sudo='sudo '
alias ag='ag -S --stats'

function hall { history -E 1 }

function brew-cask-upgrade {
  for app in $(brew cask list); do
    local latest="$(brew cask info "${app}" | awk 'NR==1{print $2}')";
    local versions=($(ls -1 "/usr/local/Caskroom/${app}/.metadata/"));
    local current=$(echo ${versions} | awk '{print $NF}');

    if [[ "${latest}" = "latest" ]]; then
      echo "[!] ${app}: ${current} == ${latest}";
      [[ "$1" = "-f" ]] && brew cask install "${app}" --force;
      continue;
    elif [[ "${current}" = "${latest}" ]]; then
      continue;
    fi;

    echo "[+] ${app}: ${current} -> ${latest}";

    brew cask uninstall "${app}" --force;
    brew cask install "${app}";
  done;
}

#
# Modules
#

# Completion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' use-cache true
zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:options' description 'yes'
# zstyle ':vcs_info:*' formats '%s][* %F{green}%b%f'
# zstyle ':vcs_info:*' actionformats '%s][* %F{green}%b%f(%F{red}%a%f)'

#
# Prompt
#

POWERLINE_SEPARATOR=$'\ue0b2'
POWERLINE_BRANCH=$'\ue0a0'

zstyle ':vcs_info:*' formats '%F{7}%K{8} '$POWERLINE_BRANCH' %b %k%f'

function precmd_vcs_info() { vcs_info }

add-zsh-hook precmd precmd_vcs_info

PROMPT='%F{2}%%%f '
RPROMPT='%F{8}%K{0}'$POWERLINE_SEPARATOR'%k%f${vcs_info_msg_0_}%F{2}%K{8}'$POWERLINE_SEPARATOR'%k%f%F{0}%K{2} %c %k%f'

#
# Other
#

# rbenv

export PATH="$HOME/.rbenv/bin:$PATH"

eval "$(rbenv init - zsh)"

#export PATH=$PATH:~/Qt5.5.1/5.5/clang_64/bin/
export PATH="/usr/local/opt/qt@5.5/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# Created by newuser for 5.3.1
#fpath=(/usr/local/share/zsh-completions $fpath)
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/usr/local/opt/sqlite/bin:$PATH"

powerline-daemon -q
. ~/.pyenv/versions/2.7.13/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

