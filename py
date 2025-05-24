#! /bin/bash
BASE="/usr/local/Caskroom/miniconda/base"
CD="$BASE/bin/conda"

col() {
  case "$1" in
    red)     echo -e "\033[31m$2\033[0m" ;;
    green)   echo -e "\033[32m$2\033[0m" ;;
    yellow)  echo -e "\033[33m$2\033[0m" ;;
    blue)    echo -e "\033[34m$2\033[0m" ;;
    *)       echo -e "$2" ;;
  esac
}

eval "$($CD shell.zsh hook)"

_py_add() {
    echo "Via $1, $2"
    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "Usage: py <env_name> <python_version>";
        return 1;
    fi

    py_ver=$2;
    env_name=$1;

    if ! [[ "$py_ver" =~ ^3\.[0-9]{1,2}$ ]]; then
        echo "Invalid version. Use format 3.x";
        return 1;
    fi

    arc=$(arch);
    col blue "New env '$env_name' on $arc Python $py_ver";

    CONDA_SUBDIR=osx-arm64 conda create --name "$env_name" python=$py_ver -y;

    if [[ $? -eq 0 ]]; then
        col green "Environment '$env_name' created successfully."
        conda activate "$env_name";
        pip install uv;
        uv pip install numpy matplotlib;

        if [[ -f "requirements.txt" ]]; then
            read -p "Install requirements.txt? [y/n]: " ireq;
            last_commit=$(git log -1 --format=%cd --date=format:%Y-%m-%d | head -n 1);

            [[ "$ireq" == "y" ]] && uv pip install -r requirements.txt --exclude-newer $last_commit;
        fi
    else
        col red "Failed to create environment '$env_name'.";
    fi
}

_py_activate() {
    if [[ -z "$1" ]]; then
        echo "Usage: py activate <env_name>";
        conda env list;
        return 1;
    fi

    \local ask_conda
    ask_conda="$(PS1="${PS1:-}" $CD 'shell.zsh' activate "$1")" || \return 1
    \eval "$ask_conda"
}

py_auto() {
    if [[ -z "$1" ]]; then
        echo "Usage: py <env_name>";
        return 1;
    fi

    env_name="$1";
    if ! py_list | awk '{print $1}' | grep -q "^$env_name$"; then
        read -p "Enter version (3.x): " py_ver;
        _py_add "$env_name" "$py_ver";
    fi
    _py_activate "$env_name";
    col blue "Using: $(which python3)";
}

py_remove() {
    if [[ -z "$1" ]]; then
        echo "Usage: py remove <env_name>";
        py_list;
        return 1;
    fi

    conda deactivate;
    conda remove --name "$1" --all -y;
}

py_list() {
    ls "$BASE/envs/";
}

case "$1" in
    remove) py_remove "$2" ;;
    list) py_list ;;
    *) py_auto "$1" ;;
esac
