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

echo

alias slm="OLLAMA_HOST=\"$GOJIRA:11434\" ollama";
alias llm="OLLAMA_HOST=\"$GOD:11434\" ollama";
alias lm="OLLAMA_HOST=\"$DRAGON:11434\" ollama";

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

# conda: detect base across machines, lazy-init so terminal load doesn't hang.
for __cb in /opt/homebrew/Caskroom/miniconda/base /usr/local/Caskroom/miniconda/base; do
    [ -x "$__cb/bin/conda" ] && export CONDA_BASE="$__cb" && break
done
unset __cb
if [ -n "$CONDA_BASE" ]; then
    # stub: first call swaps itself for the real conda (~0.3s hook paid once, on use)
    conda(){
        unset -f conda
        eval "$("$CONDA_BASE/bin/conda" shell.zsh hook)"
        conda "$@"
    }
fi

# py: activation must run in this shell; everything else delegates to the script.
py(){
    case "$1" in
        ""|conf|i|add|remove|list) command py "$@" ;;
        do) conda activate "$2" ;;
        *)
            if [ -n "$2" ]; then
                command py "$@"            # py <name> <3.x> -> create flow
            else
                local __t
                __t=$(command py __resolve "$1")  # fuzzy-resolve, listing -> stderr
                [ -n "$__t" ] && conda activate "$__t"
            fi
            ;;
    esac
}

export PATH="$HOME/.local/bin:$PATH"

export PATH=/Users/dragon/.opencode/bin:$PATH;

if [ -d "$HOME/.vite-plus" ]; then
  . "$HOME/.vite-plus/env"
fi
# quasar
export PATH="/Users/dragon/.local/bin:$PATH"
export PATH="/usr/local/opt/libpcap/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
