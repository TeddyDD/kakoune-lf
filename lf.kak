declare-option -hidden -docstring "id of currently active lf instance" str lf_id "none"
declare-option -docstring "Kakoune command used to spaw lf in terminal
It has to spawn lf and export following enviroment varibles:
KAKLF=yes
kak_session
kak_client

'lf-spawn-new' is used by default, feel free to override it" \
str lf_terminal_cmd lf-spawn-new

hook global KakEnd .* %{
	try %{ lf-send-command 'quit' }
}

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
