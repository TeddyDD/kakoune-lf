declare-option -hidden -docstring "id of currently active lf instance" str lf_id "none"
declare-option -hidden str lf_tmp_file
declare-option -docstring "Kakoune command used to spaw lf in terminal
It has to spawn lf and export following enviroment varibles:
KAKLF=yes
kak_session
kak_client

'lf-spawn-new' is used by default, feel free to override it" \
str lf_terminal_cmd lf-spawn-new

# When lf_id is set, configure lf instance
hook -group lf global GlobalSetOption 'lf_id=\d+' %{
    lf-send-configuration '
    cmd kak-edit &{{
        for c in $fx
        do
            echo "evaluate-commands -client $kak_client %{edit ''$c''}" | kak -p "$kak_session"
        done
    }}
    cmd kak-cmd &{{
        echo "evaluate-commands -client $kak_client $*" | kak -p $kak_session
    }}
    set nopreview
    set ratios 1
    cmd open :kak-edit
    map q :kak-exit-hook
    '
}

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

define-command -hidden lf-spawn-new %{
    hatch-terminal %{
        env KAKLF="yes" lf $(basename $kak_buffile)
    }
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

