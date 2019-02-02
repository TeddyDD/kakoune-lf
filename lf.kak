declare-option -hidden -docstring "id of currently active lf instance" str lf_id "none"
declare-option -docstring "Kakoune command used to spaw lf in terminal
It has to spawn lf and export following enviroment varibles:
KAKLF=yes
kak_session
kak_client

'lf-spawn-new' is used by default, feel free to override it" \
str lf_terminal_cmd lf-spawn-new

	hatch-terminal %{
		env KAKLF="yes" lf $(basename $kak_buffile)
	}
}
