alias x86do="arch -x86_64";
alias armdo="arch -arm64";
alias cat="bat";
alias ls="eza --icons";
alias ll="eza -la --icons";
alias wget="aria2c";
alias docker="podman";

# rm ~/.zshrc
# ln -s ~/Documents/Applications.nosync/bin/dots/.zshrc ~/.zshrc
DOC="$HOME/Documents"
DOW="$HOME/Downloads"
USER="gojira"

alias github="cd $DOC/GitHub.nosync/ && ls";
alias iitm="cd $DOC/GitHub.nosync/IITM && ls";
alias dcpp="cd $DOW/DC++ && ls";
alias amos="cd $DOC/GitHub.nosync/amos && ls";

ZSH_DISABLE_COMPFIX=true;
ZSH_THEME="robbyrussell";
UBIN="$DOC/bin"

plugins=(git)

export ZSH="$HOME/.oh-my-zsh";
source "$UBIN/dots/antigen.zsh";
source "$UBIN/dots/tokens";
source "$ZSH/oh-my-zsh.sh";

alias llm="OLLAMA_HOST=\"$GOD:11434\" ollama"

antigen bundle zsh-users/zsh-autosuggestions;
antigen bundle zsh-users/zsh-history-substring-search;
antigen bundle zsh-users/zsh-syntax-highlighting;
antigen apply;

# zsh-history-substring-search configuration
bindkey '^[[A' history-substring-search-up # or '\eOA'
bindkey '^[[B' history-substring-search-down # or '\eOB'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

export PATH="$PATH:/opt/homebrew/lib/node_modules/:/Users/$USER/go/bin:/opt/homebrew/sbin:/Users/$USER/.cargo/bin:/Users/$USER/.bun/bin:/opt/homebrew/bin:/Users/$USER/.local/bin:/Users/$USER/.wasmer/bin:/opt/homebrew/Cellar/nginx/1.25.5/bin:$DOC/bin:$HOME/.lmstudio/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH";


# BEG opam
[[ ! -r '$HOME/.opam/opam-init/init.zsh' ]] || source '$HOME/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam

export ANDROID_HOME="$HOME/Library/Android/sdk";
export PATH="$PATH:$ANDROID_HOME/emulator";
export PATH="$PATH:$ANDROID_HOME/platform-tools";
export PATH="$PATH:/opt/homebrew/bin/";

export PATH="/usr/local/opt/ruby/bin:$PATH";
export PATH="/usr/local/lib/ruby/gems/3.4.0/bin:$PATH";
export PATH="/usr/local/sbin:$PATH";

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"

export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=/Users/god/.opencode/bin:$PATH

__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup