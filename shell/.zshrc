#!/bin/zsh

# =============== aliases =============== #

source ~/.shrc
alias sss='source ~/.zshrc'

# =============== history =============== #

export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
export HISTFILESIZE=$HISTSIZE
export HISTTIMEFORMAT="[%F %T] "
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# =============== prompt option =============== #

# color
autoload -U colors && colors

# prompt
setopt prompt_subst
prompt_print() {
    local prompt_triangle=$'\uE0B0'
    local prompt_bg=${prompt_bg:-223}
    local prompt_fg=${prompt_fg:-16}
    local prompt_next_bg=${prompt_next_bg:-16}
    local prompt_data=${prompt_data}
    echo -n "%K{${prompt_bg}}%F{${prompt_fg}} ${prompt_data} %f%k%K{${prompt_next_bg}}%F{${prompt_bg}}${prompt_triangle}%f%k"
}
colorcode() {
    local text=${1}
    local hash=$(echo -n ${text} | md5sum | cut -d ' ' -f 1)
    local number=$(( 0x${hash:0:4} ))
    local scaled_number=$(( number % 255 ))
    echo $scaled_number
}
netgeo() {
    local tty proxy_file proxy_last proxy_now netgeo_file netgeo_modtime

    tty=$(tty | sed 's/\/dev\/pts\///')
    netgeo_file="/tmp/.netgeo_geo__tty${tty}"
    proxy_file="/tmp/.netgeo_proxy__tty${tty}"

    netgeo_modtime=$(stat -c %Y ${netgeo_file} 2> /dev/null)
    proxy_last=$(cat ${proxy_file} 2> /dev/null)
    proxy_now=$(echo -e "${http_proxy}\n${https_proxy}\n${HTTP_PROXY}\n${HTTPS_PROXY}" | tee "${proxy_file}")

    if [[ -f "${netgeo_file}" ]]; then
        cat ${netgeo_file} | jq -r '"\(.city) (\(.country))"'
    fi
    if [[ "${proxy_now}" != "${proxy_last}" ]]; then
        curl -s "https://ipinfo.io/json" 2> /dev/null > ${netgeo_file}
    fi
    if [[ -z "${netgeo_modtime}" ]] || [[ $(( $(date +%s) - ${netgeo_modtime} )) -gt 300 ]]; then
        nohup curl -s "https://ipinfo.io/json" 2> /dev/null > ${netgeo_file} &
    fi
}
prompt() {
    ret=$?
    prompt_configs=()
    if [[ $ret -ne 0 ]]; then
        prompt_configs+=("${ret}" "16" "%?")
    else
        prompt_configs+=("223" "16" "%?")
    fi
    prompt_configs+=("114" "16" "%n")
    prompt_configs+=("$(colorcode "$(hostname)")" "16" "%M")
    prompt_configs+=("42"  "16" "$(date "+%Y-%m-%d")")
    prompt_configs+=("36"  "16" "$(date "+%H:%M:%S")")
    prompt_configs+=("29"  "16" "$(date "+%Z")")
    prompt_configs+=("223" "16" "%~")
    prompt_configs+=("38"  "16" "$(go version | cut -d " " -f 3)")
    prompt_configs+=("$(colorcode "$(netgeo)")" "16" "$(netgeo)")
    prompt_configs+=("68"  "16" "$(git branch --show-current 2&> /dev/null | xargs -I branch echo " branch")")
    echo "%B"
    for (( i=1; i<${#prompt_configs[@]}; i+=3 )); do
        prompt_bg=${prompt_configs[i]}
        prompt_fg=${prompt_configs[i+1]}
        prompt_data=${prompt_configs[i+2]}
        if [ $i -eq $((${#prompt_configs[@]}-3)) ]; then
            prompt_next_bg=16
        else
            prompt_next_bg=${prompt_configs[i+3]}
        fi
        prompt_print
    done
    echo "%b"
    echo "%F{117} ➤  %f"
}
PROMPT='$(prompt)'

# =============== fzf =============== #

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# =============== plugin =============== #

if [[ ${plugin_loaded} != "true" ]]; then
    echo "loading plugin..."

    plugins=(docker docker-compose)
    fpath=(~/.zsh/completion $fpath)
    autoload -Uz compinit && compinit -i

    if [[ ! -d ~/.zsh/plugins/zsh-autosuggestions ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
    fi
    source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

    if [[ ! -d ~/.zsh/plugins/zsh-syntax-highlighting ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
    fi
    source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    plugin_loaded="true"
fi

# =============== window title =============== #

#DISABLE_AUTO_TITLE="true"
set-window-title() {
    # pwd_short=$(sed 's:\([^/]\)[^/]*/:\1/:g' <<< $PWD)
    pwd_base=$(basename $PWD)
    title="${USER}@$(hostname -s) : ${pwd_base}"

    git_remote=$(git remote -v 2> /dev/null | head -n1 | awk '{print $2}')
    if [[ -n "${git_remote}" ]]; then
        git_repo=$(basename ${git_remote} | awk -F. '{print $1}')
        title="${git_repo} | ${title}"
    fi

    window_title="\e]0;${title}\a"
    echo -ne "$window_title"
}
set-window-title
add-zsh-hook precmd set-window-title
