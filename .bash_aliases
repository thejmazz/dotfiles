alias cls="clear; ls"
alias ll="ls++ --potsf"

# alias tmux="tmux -2"
#alias tmux="TERM=screen-256color tmux"
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias ctl='clear; tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'
alias tta="ta 0"

alias dps="docker ps --format 'table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias gpg=gpg2

# alias cdup="cd `git rev-parse --show-toplevel`"
function cdup() {
    cd `git rev-parse --show-toplevel`
}

alias ossh="openstack server ssh -l ubuntu --public"

function src() {
    [[ "$SHELL" == *"zsh" ]] && source ~/.zshrc
    [[ "$SHELL" == *"bash" ]] && source ~/.bashrc
}
