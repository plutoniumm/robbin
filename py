#!/bin/bash
eval "$(conda shell.bash hook)";

_py_add() {
    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "Usage: py add <env_name> <py_version>";
        return 1;
    fi

    py_version=$2;
    env_name=$1;

    echo "Creating environment '$env_name' with Python $py_version...";
    conda create --name "$env_name" python=$py_version -y;

    if [[ $? -eq 0 ]]; then
        echo "Environment '$env_name' created successfully."
        conda activate "$env_name";
        pip install uv;
        uv pip install numpy pandas matplotlib;

        if [[ -f "requirements.txt" ]]; then
            read -p "Install requirements.txt? [y/n]: " ireq;
            last_commit=$(git log -1 --format=%cd --date=format:%Y-%m-%d | head -n 1);

            [[ "$ireq" == "y" ]] && uv pip install -r requirements.txt --exclude-newer $last_commit;
        fi
    else
        echo "Failed to create environment '$env_name'.";
    fi
}

_py_activate() {
    if [[ -z "$1" ]]; then
        echo "Usage: py activate <env_name>";
        conda env list;
        return 1;
    fi

    env_name=$1;
    # conda activate "$env_name";

    \local ask_conda
    ask_conda="$(PS1="${PS1:-}" __conda_exe shell.posix "$@")"  || \return
    \echo "$ask_conda"
    echo __conda_hashr
}

# test run
_py_activate shotty


py_auto() {
    if [[ -z "$1" ]]; then
        echo "Usage: py <env_name>";
        return 1;
    fi

    env_name=$1;

    if conda env list | awk '{print $1}' | grep -q "^$env_name$"; then
        conda activate "$env_name";
    else
        read -p "Create '$env_name' env. py ver?: " py_version;
        _py_add "$env_name" "$py_version";
    fi
}

py_remove() {
    read -p "Enter environment name to remove: " env_name;
    conda deactivate;
    conda remove --name "$env_name" --all -y;
}

py_list() {
    echo "Available Conda environments:";
    conda env list;
}

case "$1" in
    remove) py_remove ;;
    list) py_list ;;
    *) py_auto "$1" ;;
esac
