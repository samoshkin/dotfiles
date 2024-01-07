export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# ZSH completions for kubectl
# TODO: install through antigen
source <(kubectl completion zsh)

# aliases
alias k=kubectl

alias k-get-all="kubectl api-resources --verbs=list --namespaced -o name | tr '\n' ',' | sed 's/,$/\n/' | xargs kubectl get --ignore-not-found --show-kind"
