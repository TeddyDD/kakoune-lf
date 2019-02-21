declare-option -hidden -docstring "id of currently active lf instance" str lf_id "none"
declare-option -hidden str lf_tmp_file
declare-option -hidden str lf_start_dir
declare-option -docstring "Kakoune command used to spaw lf in terminal
It has to spawn lf and export following enviroment varibles:
KAKLF=yes
kak_session
kak_client

'lf-spawn-new' is used by default, feel free to override it" \
str lf_terminal_cmd lf-spawn-new
declare-option -docstring "List of regexes, that will be matched against a file's mimetype before opening" str-list lf_openables 'text/.*' 'application/json'
declare-option -docstring 'Should lf jump to the file opened in kakoune' bool lf_follow false

# When lf_id is set, configure lf instance
hook -group lf global GlobalSetOption 'lf_id=\d+' %{
    lf-send-configuration %sh{
        echo '
        cmd kak-exit-hook &{{
            echo "eval -client $kak_client set-option global lf_id none" | kak -p "$kak_session"
            lf -remote "send $id quit"
        }}
        cmd kak-edit %{{
            grep_args="$(echo '"$kak_opt_lf_openables"' | tr -d "'\''" | xargs -d " " -I "{}" echo "-e \"{}\" " | tr -d "\n")"
            cnt=0
            for c in $fx
            do
                if file -b --mime-type "$(realpath "$c")" | sh -c "grep -Eqm 1 $grep_args"; then
                    echo "evaluate-commands -client $kak_client %{edit '\''$c'\''}" | kak -p "$kak_session" 2>&1 /dev/null
                    cnt=$((cnt+1))
                fi
            done
            echo "$cnt files opened"
        }}
        cmd kak-cmd &{{
            echo "evaluate-commands -client $kak_client $*" | kak -p $kak_session
        }}
        cmd lf-sync-cwd &{{
            dir="$(dirname ""$f"")"
            echo "evaluate-commands -client $kak_client ''lf-join-cd %{$dir}''" | kak -p $kak_session
        }}
        set nopreview
        set ratios 1
        cmd open :kak-edit
        map q :kak-exit-hook
        '
    }
}

define-command -hidden -params 1.. lf-join-cd %{
    cd "%sh{echo $* | sed 's! !\ !'}"
}

define-command lf-follow -docstring 'find directory of current buffer in lf' %{
    lf-set-start-dir
    lf-send-command "cd '%opt{lf_start_dir}'"
    lf-send-command "select '%val{buffile}'"
}

define-command lf-sync-cwd -docstring 'open Kakoune''s CWD in running lf instance' %{
	lf-send-command "cd '%sh{pwd}'"
}

hook -group lf global GlobalSetOption 'lf_follow=(true|false)' %{ evaluate-commands %sh{
    case $kak_opt_lf_follow in
        true)
            echo '
            hook -group lf-update-path global WinDisplay .* %{
                lf-follow
            }' ;;
        false) echo 'remove-hooks global lf-update-path' ;;
    esac
}}

hook -group lf global KakEnd .* %{
    try %{ lf-send-command 'quit' }
}

define-command lf -docstring 'Open/close lf as file browser' %{
    evaluate-commands %sh{
        if [ "$kak_opt_lf_id" = "none" ]; then
            echo "$kak_opt_lf_terminal_cmd"
        else
            echo "lf-send-command 'kak-exit-hook'"
        fi
    }
}

# Helper that sets lf_start_dir to path that contains buffile
# If buffile does not exsists it sets lf_start_dir to Kakoune's pwd
define-command -hidden lf-set-start-dir %{
    evaluate-commands %sh{
        d="$kak_buffile"
        if [ -e "$d" ]; then
            d="$(echo "${kak_buffile%/*}/" | sed 's! !\ !')"
            printf 'set-option global lf_start_dir %%{%s}\n' "$d"
        else
            printf '%s\n' "set-option global lf_start_dir %{$(pwd | sed 's! !\ !')/}"
        fi
    }
}

define-command -hidden lf-spawn-new %{
    lf-set-start-dir
    terminal sh -c "env kak_session=%val{session} kak_client=%val{client} lf -command '&echo eval -client $kak_client set-option global lf_id $id | kak -p $kak_session' ""%opt{lf_start_dir}"""
}

define-command -hidden lf-send-command \
    -params 1.. \
    -docstring 'send command to currently attached lf instance' %{
    evaluate-commands %sh{
        if [ -n "$kak_opt_lf_id" ]; then
            lf -remote "send $kak_opt_lf_id $*"
        else
            echo fail "No lf session attached"
        fi
    }
}

define-command -hidden lf-send-configuration \
    -params 1 \
    -docstring "send multiple lines of configuration to attached lf instance" %{
    evaluate-commands %sh{
        tmp="$(mktemp ${TMPDIR:-/tmp}/kaklf.XXXXXXXXX)"
        printf "set-option global lf_tmp_file '%s'\n" "$tmp"
        printf '%s\n' "$*" > $tmp
        printf 'lf-send-command "source %s"\n' "$tmp"
    }
    nop %sh{
        rm "$kak_opt_lf_tmp_file"
    }
}

