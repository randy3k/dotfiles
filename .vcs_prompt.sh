# Shared VCS prompt logic for Bash and Zsh

_vcs_strip_osc() {
    sed 's/\x1b][0-9]*;[^\a\x1b]*\(\a\|\x1b\\\)//g'
}

# Usage: vcs_prompt_info <red> <green> <yellow> <reset>
vcs_prompt_info() {
    local red="$1"
    local green="$2"
    local yellow="$3"
    local reset="$4"

    # 1. Try Jujutsu (jj)
    if command -v jj >/dev/null && jj root >/dev/null 2>&1; then
        local jj_out
        jj_out=$(jj log --no-pager --color=never --no-graph \
            -r '(latest(bookmarks() & ancestors(@, 1000)) | @)' \
            -T 'if(local_bookmarks, "B:" ++ local_bookmarks ++ "\n") ++ if(current_working_copy, "S:" ++ if(empty, "c", "d") ++ " I:" ++ change_id.short() ++ "\n")' \
            2>/dev/null | _vcs_strip_osc)
        
        if [[ -n "$jj_out" ]]; then
            local branch="" dirty="" id=""
            while IFS= read -r line; do
                if [[ "$line" == B:* ]]; then
                    # Pick the first local bookmark if there are multiple
                    local b_all="${line#B:}"
                    branch="${b_all%% *}"
                elif [[ "$line" == S:* ]]; then
                    [[ "${line:2:1}" == "d" ]] && dirty="*"
                    id="${line#* I:}"
                fi
            done <<< "$jj_out"
            branch="${branch:-$id}"

            if [[ "$dirty" == "*" ]]; then echo -en " ${red}"; else echo -en " ${green}"; fi
            echo -en "(${branch}${dirty})${reset}"
            return
        fi
    fi

    # 2. Try Git
    local st
    st=$(git status -b --porcelain 2>/dev/null)
    if [[ $? -eq 0 ]]; then
        local branch dirty="" unpushed=""
        branch=$(git symbolic-ref HEAD --short 2> /dev/null || (git branch | sed -n 's/\* (*\([^)]*\))*/\1/p'))
        [[ $(wc -l <<< "$st") -gt 1 ]] && dirty="*"
        
        # Portable regex for both shells
        if [[ "$st" =~ "behind "([0-9]+) ]]; then
            if [[ -n ${BASH_REMATCH[1]} ]]; then unpushed="-${BASH_REMATCH[1]}"; else unpushed="-${match[1]}"; fi
        fi
        if [[ "$st" =~ "ahead "([0-9]+) ]]; then
            if [[ -n ${BASH_REMATCH[1]} ]]; then unpushed="${unpushed}+${BASH_REMATCH[1]}"; else unpushed="${unpushed}+${match[1]}"; fi
        fi

        if [[ -n "$dirty" ]]; then echo -en " ${red}";
        elif [[ -n "$unpushed" ]]; then echo -en " ${yellow}";
        else echo -en " ${green}"; fi
        echo -en "(${branch}${dirty}${unpushed})${reset}"
        return
    fi
}

# Usage: citc_prompt_info <red> <green> <yellow> <reset>
citc_prompt_info() {
    local red="$1"
    local green="$2"
    local yellow="$3"
    local reset="$4"

    if [[ "$PWD" != *"/google/src/cloud/$USER/"* ]]; then
        return
    fi

    local rel_path="${PWD##*/google/src/cloud/$USER/}"
    local client="${rel_path%%/*}"
    local client_root="/google/src/cloud/$USER/$client"
    local dirty="" unpushed="" jj_success=0

    if [[ -d "$client_root/.jj" ]]; then
        local jj_st
        jj_st=$(jj st --no-pager --color=never -R "$client_root" --quiet 2>/dev/null | _vcs_strip_osc)
        if [[ $? -eq 0 ]]; then
            jj_success=1
            if [[ ! $(echo "$jj_st" | head -n 1) =~ "The working copy has no changes." ]]; then dirty="*"
            else
                local parent_cl=$(echo "$jj_st" | sed -n 's/^Parent.*\(cl\/[^ ]*\).*/\1/p')
                [[ "$parent_cl" == *"*" ]] && unpushed="true"
            fi
        fi
    fi

    if [[ $jj_success -ne 1 && -d "$client_root/.hg" ]]; then
        if [[ -n $(hg --cwd "$client_root" st 2>/dev/null) ]]; then dirty="*"
        elif [[ $(hg --cwd "$client_root" ll -r . 2>/dev/null) =~ "will update" ]]; then unpushed="true"
        fi
    fi

    if [[ "$dirty" == "*" ]]; then echo -en " ${red}";
    elif [[ "$unpushed" == "true" ]]; then echo -en " ${yellow}";
    else echo -en " ${green}"; fi
    echo -en "(${client}${dirty})${reset}"
}
