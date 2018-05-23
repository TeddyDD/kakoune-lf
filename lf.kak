define-command lf -docstring 'Open lf as file browser' %{
	hatch-terminal %{
		env KAKLF="yes" lf $(basename $kak_buffile)
	}
}
