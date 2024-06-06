typeset -g GH_COPILOT_RESULT_FILE
typeset -g RESET
typeset -g RED
typeset -g GREEN

GH_COPILOT_RESULT_FILE="${GH_COPILOT_RESULT_FILE:-/tmp/zsh_gh_copilot_result}"

if type tput >/dev/null; then
    RESET="$(tput sgr0)"
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
else
    RESET=""
    RED=""
    GREEN=""
fi

_echo_exit() {
    printf "%s%s%s" "$RED" "$@" "$RESET" >&2
    return 1
}

type tput >/dev/null || _echo_exit "zsh-github-copilot: tput not found."
type gh >/dev/null || _echo_exit "zsh-github-copilot: gh not found."
gh extension list | grep -q "gh-copilot" || _echo_exit "zsh-github-copilot: gh copilot extension not found."

_gh_copilot() {
    # run gh copilot without interactivity
    echo "" | gh copilot "$@" 2>/dev/null
}

_spinner() {
    local pid=$1
    local delay=0.1
    local spin='⣾⣽⣻⢿⡿⣟⣯⣷'

    cleanup() {
        # shellcheck disable=SC2317
        kill "$pid"
        # shellcheck disable=SC2317
        tput cnorm
    }
    trap cleanup SIGINT

    i=0
    # while the copilot process is running
    tput civis
    while kill -0 "$pid" 2>/dev/null; do
        i=$(((i + 1) % ${#spin}))
        printf "  %s%s%s" "${RED}" ${spin:$i:1} "${RESET}"
        sleep "$delay"
        printf "\b\b\b"
    done
    printf "   \b\b\b"
    tput cnorm
    trap - SIGINT
}

_gh_copilot_spinner() {
    # run gh copilot in the background and show a spinner
    read -r < <(
        _gh_copilot "$@" >"$GH_COPILOT_RESULT_FILE" &
        echo $!
    )
    _spinner "$REPLY" >&2
    cat "$GH_COPILOT_RESULT_FILE"
}

_gh_copilot_explain() {
    local result
    local pattern
    # the explanation starts with a bullet point
    pattern='^\s*•'
    result="$(
        _gh_copilot_spinner explain "$@" |
            grep "$pattern"
    )"
    __trim_string "$result"
}

_gh_copilot_suggest() {
    local result
    local pattern
    # the suggestions start with 4 spaces
    pattern='^    '
    result="$(
        _gh_copilot_spinner suggest -t shell "$@" |
            grep "$pattern"
    )"
    __trim_string "$result"
}

__trim_string() {
    # reomve leading and trailing whitespaces
    # from https://github.com/dylanaraps/pure-bash-bible?tab=readme-ov-file#trim-leading-and-trailing-white-space-from-string
    # Usage: trim_string "   example   string    "
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

_prompt_msg() {
    # print a message to the prompt
    printf "\n%s%s%s\n\n" "$GREEN" "$@" "$RESET"
    # this isn't great because it might not work with multiline prompts
    zle reset-prompt
}

zsh_gh_copilot_suggest() {
    # based on https://github.com/stefanheule/zsh-llm-suggestions/blob/master/zsh-llm-suggestions.zsh#L65
    # check if the buffer is empty
    [ -z "$BUFFER" ] && return
    zle end-of-line

    local result
    # place the query in history
    print -s "$BUFFER"
    result="$(_gh_copilot_suggest "$BUFFER")"
    [ -z "$result" ] && _prompt_msg "No suggestion found" && return
    zle reset-prompt
    # replace the current buffer with the result
    BUFFER="${result}"
    # shellcheck disable=SC2034
    CURSOR=${#BUFFER}
}

zsh_gh_copilot_explain() {
    # based on https://github.com/stefanheule/zsh-llm-suggestions/blob/master/zsh-llm-suggestions.zsh#L71
    # check if the buffer is empty
    [ -z "$BUFFER" ] && return
    zle end-of-line

    local result
    result="$(_gh_copilot_explain "$BUFFER")"
    _prompt_msg "${result:-No explanation found}"
}

zle -N zsh_gh_copilot_suggest
zle -N zsh_gh_copilot_explain
