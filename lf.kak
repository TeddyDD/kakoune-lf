declare-option -docstring "id of currently active lf instance" str lf_id 
define-command lf -docstring 'Open lf as file browser' %{
	hatch-terminal %{
		env KAKLF="yes" lf $(basename $kak_buffile)
	}
}
