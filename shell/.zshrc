#!/bin/zsh

# =============== utils =============== #

time_it() {
  local name="${1:-Command}"
  local start_time
  start_time=$(date +%s%3N)

  shift && "$@"

  echo "${name} loaded in $(($(date +%s%3N) - start_time))ms"
}

# =============== aliases =============== #

time_it "shrc" source ~/.shrc
alias sss='source ~/.zshrc'

# =============== bindkey =============== #

bindkey -e

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
  local prompt_separator=$'\uE0B4'
  local prompt_bg=${prompt_bg:-223}
  local prompt_fg=${prompt_fg:-16}
  local prompt_next_bg=${prompt_next_bg:-16}
  local prompt_data=${prompt_data}
  echo -n "%K{${prompt_bg}}%F{${prompt_fg}} ${prompt_data} %f%k%K{${prompt_next_bg}}%F{${prompt_bg}}${prompt_separator}%f%k"
}

rprompt_print() {
  local rprompt_separator=$'\uE0B6'
  local rprompt_bg=${rprompt_bg:-223}
  local rprompt_fg=${rprompt_fg:-16}
  local rprompt_last_bg=${rprompt_last_bg:-16}
  local rprompt_data=${rprompt_data}
  # echo -n "%K{${rprompt_bg}}%F{${rprompt_fg}} ${rprompt_data} %f%k%K{${rprompt_last_bg}}%F{${rprompt_bg}}${rprompt_separator}%f%k"
  echo -n "%K{${rprompt_last_bg}}%F{${rprompt_bg}}${rprompt_separator}%f%k%K{${rprompt_bg}}%F{${rprompt_fg}} ${rprompt_data} %f%k"
}

colorcode() {
  local text=${1}
  local hash=$(echo -n ${text} | md5sum | cut -d ' ' -f 1)
  local number=$(( 0x${hash:0:4} ))
  local scaled_number=$(( number % 255 ))
  echo $scaled_number
}

netgeo_init() {
  local geo_db geo_db_url

  geo_db="$HOME/.local/share/GeoIP/GeoLite2-City.mmdb"
  geo_db_url="https://git.io/GeoLite2-City.mmdb"

  # Install mmdblookup if missing
  if ! command -v mmdblookup &> /dev/null; then
    if command -v apt &> /dev/null; then
      sudo apt install -y mmdb-bin 2> /dev/null
    elif command -v pacman &> /dev/null; then
      sudo pacman -S --noconfirm mmdb-bin 2> /dev/null
    fi
  fi

  # Download geo database if missing or outdated (every 7 days)
  local db_modtime
  db_modtime=$(stat -c %Y "${geo_db}" 2> /dev/null)
  if [[ -z "${db_modtime}" ]]; then
    mkdir -p "$(dirname "${geo_db}")"
    curl -skL "${geo_db_url}" -o "${geo_db}.tmp" 2> /dev/null && mv "${geo_db}.tmp" "${geo_db}"
  elif [[ $(( $(date +%s) - ${db_modtime} )) -gt 604800 ]]; then
    nohup curl -skL "${geo_db_url}" -o "${geo_db}.tmp" 2> /dev/null \; mv "${geo_db}.tmp" "${geo_db}" &> /dev/null &
  fi
}
time_it "netgeo_db" netgeo_init

netgeo() {
  local tty proxy_file proxy_last proxy_now netgeo_file netgeo_modtime geo_db

  tty=$(tty | sed 's/\/dev\/pts\///')
  netgeo_file="/tmp/.netgeo_tty${tty}_geo"
  proxy_file="/tmp/.netgeo_tty${tty}_proxy"
  geo_db="$HOME/.local/share/GeoIP/GeoLite2-City.mmdb"

  netgeo_modtime=$(stat -c %Y ${netgeo_file} 2> /dev/null)
  proxy_last=$(cat ${proxy_file} 2> /dev/null)
  proxy_now=$(echo -e "${http_proxy}\n${https_proxy}\n${HTTP_PROXY}\n${HTTPS_PROXY}" | tee "${proxy_file}")

  # Check if refresh is needed
  local need_refresh=0
  if [[ "${proxy_now}" != "${proxy_last}" ]]; then
    need_refresh=1
  elif [[ -z "${netgeo_modtime}" ]] || [[ $(( $(date +%s) - ${netgeo_modtime} )) -gt 1800 ]]; then
    need_refresh=1
  fi

  # Refresh geo data
  if [[ ${need_refresh} -eq 1 ]]; then
    # Try local geo lookup first, fallback to API
    if [[ -f "${geo_db}" ]] && command -v mmdblookup &> /dev/null; then
      local ip result city country
      ip=$(curl -skL "https://api.ip.sb/ip" 2> /dev/null)
      if [[ -n "${ip}" ]]; then
        result=$(mmdblookup --file "${geo_db}" --ip "${ip}" city names en 2> /dev/null | grep -oP '"\K[^"]+(?=")' | head -1)
        city="${result:-Unknown}"
        result=$(mmdblookup --file "${geo_db}" --ip "${ip}" country names en 2> /dev/null | grep -oP '"\K[^"]+(?=")' | head -1)
        country="${result:-Unknown}"
        echo "{\"city\":\"${city}\",\"country\":\"${country}\"}" > "${netgeo_file}"
      fi
    else
      curl -skL "https://api.ip.sb/geoip" 2> /dev/null > "${netgeo_file}"
    fi
  fi

  # Always output from netgeo_file
  if [[ -f "${netgeo_file}" ]]; then
    cat ${netgeo_file} | jq -r '"\(.city) (\(.country))"'
  fi
}

print_prompt() {
  prompt_configs=()
  prompt_configs+=($(( $? == 0 ? 223 : $? )) "16" "%?")
  prompt_configs+=("111" "16" "tty$(tty | sed 's/\/dev\/pts\///')")
  prompt_configs+=("114" "16" "%n")
  prompt_configs+=("$(colorcode "$(hostname)")" "16" "\ueba9  %M")
  prompt_configs+=("42"  "16" "$(date "+%Y-%m-%d")")
  prompt_configs+=("36"  "16" "$(date "+%H:%M:%S")")
  prompt_configs+=("29"  "16" "$(date "+%Z")")
  prompt_configs+=("223" "16" "%~")
  prompt_configs+=("68"  "16" "$(git branch --show-current 2&> /dev/null | xargs -I branch echo "\ue725 branch")")
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
}

print_rprompt() {
    # icon is generate from https://www.nerdfonts.com/cheat-sheet
    rprompt_configs=()
    rprompt_configs+=("38"  "16"  "\ue627  $(go version 2>/dev/null | sed 's/go version go\([0-9\.]*\) .*/\1/') ")
    rprompt_configs+=("221" "16"  "\ue73c  $(python3 -V 2>/dev/null | sed 's/Python \([0-9\.]*\).*/\1/') ")
    rprompt_configs+=("166" "16"  "\uf323  $(cargo version 2>/dev/null | sed 's/cargo \([0-9\.]*\) .*/\1/') ")
    rprompt_configs+=("21"  "189" "\ue620  $(lua -v 2>&1 | sed 's/Lua \([0-9]*\.[0-9]*\.[0-9]*\).*/\1/') ")
    rprompt_configs+=("214" "16"  "\ue738  $(command -v java >/dev/null && java -version 2>&1 | head -n1 | sed 's/\(.*\) version "\(.*\)" .*/\2/') ")
    rprompt_configs+=("22"  "189" "\ued0d  $(node -v 2>/dev/null | sed 's/v\([0-9\.]*\)/\1/') ")
    rprompt_configs+=("$(colorcode "$(netgeo)")" "16" "\uf450  $(netgeo)")
    for (( i=1; i<${#rprompt_configs[@]}; i+=3 )); do
        rprompt_bg=${rprompt_configs[i]}
        rprompt_fg=${rprompt_configs[i+1]}
        rprompt_data=${rprompt_configs[i+2]}
        if [ $i -eq 1 ]; then
            rprompt_last_bg=16
        else
            rprompt_last_bg=${rprompt_configs[i-3]}
        fi
        rprompt_print
    done
}

prompt() {
  echo "%B"
  print_prompt
  echo "%b"
  echo "%F{226}%(1j.[%j].)%f%F{117} ➤  %f"
}

rprompt() {
  print_rprompt
}

PROMPT='$(prompt)'
RPROMPT='$(rprompt)'

# =============== plugin =============== #

if [[ ${plugin_loaded} != "true" ]]; then
    plugins=(docker docker-compose)
    fpath=(~/.zsh/completion $fpath)
    autoload -Uz compinit && compinit -i

    load_fzf-tab() {
      if [[ ! -d ~/.zsh/plugins/fzf-tab ]]; then
          git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/plugins/fzf-tab
      fi
      source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
    }
    time_it "fzf-tab" load_fzf-tab

    load_zsh-autosuggestions() {
      if [[ ! -d ~/.zsh/plugins/zsh-autosuggestions ]]; then
          git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
      fi
      source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    }
    time_it "zsh-autosuggestions" load_zsh-autosuggestions

    load_zsh-syntax-highlighting() {
      if [[ ! -d ~/.zsh/plugins/zsh-syntax-highlighting ]]; then
          git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
      fi
      source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    }
    time_it "zsh-syntax-highlighting" load_zsh-syntax-highlighting

    load_zsh_codex() {
      if [[ ! -d ~/.zsh/plugins/zsh_codex ]]; then
        git clone https://github.com/tom-doerr/zsh_codex.git ~/.zsh/plugins/zsh_codex
      fi
      source ~/.zsh/plugins/zsh_codex/zsh_codex.plugin.zsh
      bindkey '^X' create_completion
    }
    time_it "zsh_codex" load_zsh_codex

    plugin_loaded="true"
fi

# =============== window title =============== #

#DISABLE_AUTO_TITLE="true"
set-window-title() {
    # pwd_short=$(sed 's:\([^/]\)[^/]*/:\1/:g' <<< $PWD)
    # pwd_base=$(basename $PWD)
    # title="${USER}@$(hostname -s) : ${pwd_base}"
    title="${USER}@$(hostname)"

    # git_remote=$(git remote -v 2> /dev/null | head -n1 | awk '{print $2}')
    # if [[ -n "${git_remote}" ]]; then
    #     git_repo=$(basename ${git_remote} | awk -F. '{print $1}')
    #     title="${git_repo} | ${title}"
    # fi

    window_title="\e]0;${title}\a"
    echo -ne "$window_title"
}
set-window-title
add-zsh-hook precmd set-window-title

# =============== end =============== #

fortune -s | cowsay | lolcat
