#! /bin/bash
BASE="/usr/local/Caskroom/miniconda/base"
CD="/opt/homebrew/bin/conda"

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
        uv pip install torch numpy mlx scipy sympy black;
    fi
}

_py_do(){
    source "$BASE/bin/activate" "$1"
}

case "$1" in
    conf) _py_conf ;;
    i) _py_install "$@" ;;
    do) _py_do "$2" ;;
    remove) py_remove "$2" ;;
    list) py_list ;;
    *) _py_add "$1" "$2" ;;
esac