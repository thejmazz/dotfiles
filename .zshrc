# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep

bindkey -v
bindkey '^R' history-incremental-search-backward

zstyle ':completion:*' menu select

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit -u

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^K" up-line-or-beginning-search
bindkey "^J" down-line-or-beginning-search

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%b"
precmd() {
    vcs_info
}

[[ -f $HOME/.local/share/icons-in-terminal/icons_bash.sh ]] && source $HOME/.local/share/icons-in-terminal/icons_bash.sh

[[ `hostname` == "air" ]] && source $HOME/.zsh/ensure-enabled-tmux.sh

# antibody bundle mafredri/zsh-async
# antibody bundle sindresorhus/pure

setopt prompt_subst
# PROMPT="|> "
PROMPT="❯ "
[[ -n "$SSH_CLIENT" ]] && PROMPT="[%n@%M] $PROMPT"

MYRIGHT="%~"
[[ `print -P "%~"` == "~" ]] && MYRIGHT=""
[[ ! -z "${vcs_info_msg_0_}" ]] && MYRIGHT="[ ${vcs_info_msg_0_}] $MYRIGHT"
[[ ! -z "${AWS_PROFILE}" ]] && MYRIGHT="[ ${AWS_PROFILE}] $MYRIGHT"
[[ ! -z "${OS_PROJECT_NAME}" ]] && MYRIGHT="[ ${OS_PROJECT_NAME}] $MYRIGHT"
RPS1="$MYRIGHT"

function zle-line-init zle-keymap-select {
    LEFT="==>"; RIGHT="<=="

    N_LEFT=$LEFT; N_RIGHT=$RIGHT
    N_LEFT="<=="; N_RIGHT="==>"

    # MYRIGHT="$md_folder %~"
    # MYRIGHT="[  %~]"
    MYRIGHT="%~"
    [[ `print -P "%~"` == "~" ]] && MYRIGHT=""
    # TODO how to use environment variables for icons in zsh prompt?
    # [[ ! -z "${vcs_info_msg_0_}" ]] && MYRIGHT="[$oct_git_branch ${vcs_info_msg_0_}] $MYRIGHT"
    [[ ! -z "${vcs_info_msg_0_}" ]] && MYRIGHT="[ ${vcs_info_msg_0_}] $MYRIGHT"
    [[ ! -z "${AWS_PROFILE}" ]] && MYRIGHT="[ ${AWS_PROFILE}] $MYRIGHT"
    [[ ! -z "${OS_PROJECT_NAME}" ]] && MYRIGHT="[ ${OS_PROJECT_NAME}] $MYRIGHT"

    # RPS1="${${KEYMAP/vicmd/$N_LEFT NORMAL $N_RIGHT}/(main|viins)/$LEFT INSERT $RIGHT}"
    # RPS1="${${KEYMAP/vicmd/$N_LEFT NORMAL $N_RIGHT}/(main|viins)/[${vcs_info_msg_0_}] %~}"
    RPS1="${${KEYMAP/vicmd/$N_LEFT NORMAL $N_RIGHT}/(main|viins)/$MYRIGHT}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_CONNECTION" ]; then
    [[ -z "$DISPLAY" ]] && export DISPLAY=:0.0
fi

source ~/.zsh/aws.plugin.zsh
source ~/.zsh/os.plugin.zsh

# ALIASES
[[ "`uname`" != "Darwin" ]] && alias ls="ls --color"
[[ "`uname`" == "Darwin" ]] && alias ls="ls -G"
[[ -f $HOME/.bash_aliases ]] && source $HOME/.bash_aliases

[[ -f $HOME/.dircolors ]] && eval $(dircolors -b $HOME/.dircolors)

PATH="/home/julian/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/julian/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/julian/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/julian/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/julian/perl5"; export PERL_MM_OPT;

export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"

export EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
alias nvm-init="source $NVM_DIR/nvm.sh"
[[ "`uname`" != "Darwin" ]] && [[ -f $NVM_DIR/nvm.sh ]] && source $NVM_DIR/nvm.sh

[[ "$TMUX_PROMPT" == "1" ]] && source ~/.zsh/tmux-prompt.zsh

[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion zsh)

export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

source <(antibody init)
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle docker/cli path:contrib/completion/zsh kind:fpath
antibody bundle docker/compose path:contrib/completion/zsh kind:fpath
# Must be sourced after all custom widgets have been created (i.e., after all
# zle -N calls and after running compinit). Widgets created later will work,
# but will not update the syntax highlighting.
antibody bundle zsh-users/zsh-syntax-highlighting

# Need this for autocompletes that come from antibody to work
compinit -i
