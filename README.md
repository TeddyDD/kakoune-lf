# Kakoune lf

[LF](https://github.com/gokcehan/lf) as file browser for Kakoune

![screenshot](screen.png)

## Installation

1. Load Kakoune plugin

You can either:

- load `lf.kak` from your kakrc: `source path/to/lf.kak`
- put `lf.kak` in your autoloads directory `~/.config/kak/autoload/`

2. Add this snippet to lf config file: `~/.config/lf/lfrc`

```
# Kakoune integration

cmd kak-edit ${{
    echo "eval -client $kak_client edit $f" | kak -p "$kak_session"
}}

%{{
	if [ "$KAKLF" = "yes" ]; then
		lf -remote "send $id set nopreview"
		lf -remote "send $id set ratios 1"
		lf -remote "send $id cmd open-file :kak-edit"
	fi
}}

```

## Usage

Open lf with `:lf` command. Browse files like usually. Open files with `l` key.

## TODO

- [ ] check file type to avoid binary files
- [ ] investigate `-selection-path` option for opening multiple files at once
- [ ] cd Kakoune to selected directory
- [ ] bidirectional integration (example: Kakoune as preview for files,
    show folder containing file from grep search etc.)


