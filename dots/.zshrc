alias x86do="arch -x86_64"
alias armdo="arch -arm64"

ZSH_DISABLE_COMPFIX=true
ZSH_THEME="robbyrussell"
UBIN="/Users/gojira/Documents/Applications/bin"

plugins=(git)

export ZSH="$HOME/.oh-my-zsh";
source $UBIN/dots/antigen.zsh;
source $ZSH/oh-my-zsh.sh

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# zsh-history-substring-search configuration
bindkey '^[[A' history-substring-search-up # or '\eOA'
bindkey '^[[B' history-substring-search-down # or '\eOB'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

export PATH="$PATH:/opt/homebrew/lib/node_modules/:/Users/gojira/go/bin:/opt/homebrew/sbin:/Users/gojira/.cargo/bin:/Users/gojira/.bun/bin:/opt/homebrew/bin:/Users/gojira/dots/bin:/Users/gojira/.local/bin:/Users/gojira/.wasmer/bin:/opt/homebrew/Cellar/nginx/1.25.5/bin:/Users/gojira/Documents/Applications/bin:/Users/gojira/.lmstudio/bin"

gwall;

_conda_lazy_load() {
    unset -f conda activate
    __conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
# . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"  # commented out by conda initialize
        else
# export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"  # commented out by conda initialize
        fi
    fi
    unset __conda_setup
    conda "$@"
}

conda() {
    _conda_lazy_load "$@"
}

_lazy_load() {
    local cmd="$1"
    shift
    unset -f "$cmd"
    eval "$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    . "/Users/gojira/Documents/Applications/bin/$cmd" "$@"
}

py() {
    _lazy_load py "$@"
}

fort() {
    _lazy_load fort "$@"
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="/Users/gojira/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# BEG opam
[[ ! -r '/Users/gojira/.opam/opam-init/init.zsh' ]] || source '/Users/gojira/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="$PATH:/opt/homebrew/bin/"

# bun completions
[ -s "/Users/gojira/.bun/_bun" ] && source "/Users/gojira/.bun/_bun"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/3.4.0/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
