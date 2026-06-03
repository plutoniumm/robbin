#! /bin/bash
# conda base differs per machine; prefer the inherited one, else probe both.
if [[ -z "$BASE" ]]; then
  for b in "$CONDA_BASE" /opt/homebrew/Caskroom/miniconda/base /usr/local/Caskroom/miniconda/base; do
    if [[ -x "$b/bin/conda" ]]; then BASE="$b"; break; fi
  done
fi

col(){
  case "$1" in
    red)     echo -e "\033[31m$2\033[0m" ;;
    green)   echo -e "\033[32m$2\033[0m" ;;
    yellow)  echo -e "\033[33m$2\033[0m" ;;
    blue)    echo -e "\033[34m$2\033[0m" ;;
    *)       echo -e "$2" ;;
  esac
}

_py_add(){
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: py add <env_name> <3.x>";
        echo "   or: py <env_name> <3.x>";
        return 1;
    fi

    py_ver="$2";
    env_name="$1";

    if ! [[ "$py_ver" =~ ^3\.[0-9]{1,2}$ ]]; then
        echo "Invalid version. Use format 3.x";
        return 1;
    fi

    arc=$(arch);
    col blue "Command for new env '$env_name' on $arc Python $py_ver:";

    cmd="CONDA_SUBDIR=osx-arm64 conda create --name \"$env_name\" python=$py_ver -y --use-index-cache --quiet && conda activate \"$env_name\" && py conf";
    echo "$cmd" | pbcopy;
    echo "Copied to clipboard: $cmd";
}

_py_install(){
    shift;
    if [[ $# -eq 0 ]]; then
        echo "Usage: py i <pkg1> <pkg2> ...";
        return 1;
    fi

    if command -v uv &>/dev/null; then
        col green "Using uv";
        uv pip install "$@";
    else
        col yellow "Using pip";
        pip install "$@";
    fi
}

py_remove(){
    if [[ -z "$1" ]]; then
        echo "Usage: py remove <env_name>";
        py_list;
        return 1;
    fi

    if [[ "$CONDA_DEFAULT_ENV" == "$1" ]]; then
        conda deactivate;
    fi

    conda remove --name "$1" --all -y;
}

py_list(){
    conda env list;
}

_py_conf(){
    pip install uv;

    if [[ -f "requirements.txt" ]]; then
        uv pip install -r requirements.txt;
    else
        uv pip install torch numpy mlx scipy sympy black ipykernel;
    fi
}

# names of all conda envs (env dirs + base), one per line
_py_envs(){
    if [[ -d "$BASE/envs" ]]; then
        for d in "$BASE/envs"/*/; do
            [[ -d "$d" ]] && basename "$d";
        done
    fi
    echo "base";
}

# levenshtein distance between $1 and $2
_lev(){
    local a="$1" b="$2" la=${#1} lb=${#2} i j cost del ins sub m;
    local -a prev curr;
    for ((j=0;j<=lb;j++)); do prev[j]=$j; done
    for ((i=1;i<=la;i++)); do
        curr[0]=$i;
        for ((j=1;j<=lb;j++)); do
            [[ "${a:i-1:1}" == "${b:j-1:1}" ]] && cost=0 || cost=1;
            del=$(( prev[j] + 1 ));
            ins=$(( curr[j-1] + 1 ));
            sub=$(( prev[j-1] + cost ));
            m=$del;
            (( ins < m )) && m=$ins;
            (( sub < m )) && m=$sub;
            curr[j]=$m;
        done
        for ((j=0;j<=lb;j++)); do prev[j]=${curr[j]}; done
    done
    echo "${prev[lb]}";
}

# resolve a fuzzy env name -> print exact env to stdout, else list to stderr
_py_resolve(){
    local q="$1" e d;
    [[ -z "$q" ]] && return 1;
    local envs;
    envs=$(_py_envs);

    # exact match wins
    while IFS= read -r e; do
        [[ "$e" == "$q" ]] && { echo "$e"; return 0; }
    done <<< "$envs";

    # collect everything within 2 edits (covers transposed/switcheroo typos)
    local cands=();
    while IFS= read -r e; do
        d=$(_lev "$q" "$e");
        (( d <= 2 )) && cands+=("$e");
    done <<< "$envs";

    if (( ${#cands[@]} == 1 )); then
        echo "${cands[0]}";
        return 0;
    elif (( ${#cands[@]} > 1 )); then
        { col yellow "Ambiguous '$q' (within 2 edits):"; printf '  %s\n' "${cands[@]}"; } >&2;
        return 1;
    fi

    { col red "No env matching '$q'. Available:"; printf '  %s\n' $envs; } >&2;
    return 1;
}

case "$1" in
    conf) _py_conf ;;
    i) _py_install "$@" ;;
    remove) py_remove "$2" ;;
    list) py_list ;;
    __resolve) _py_resolve "$2" ;;
    *) _py_add "$1" "$2" ;;
esac
