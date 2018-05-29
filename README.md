# Kakoune lf

[LF](https://github.com/gokcehan/lf) as file browser for Kakoune

![screenshot](screen.png)

## Installation

1. Install `hatch-terminal` from [Kakoune-extra](https://github.com/lenormf/kakoune-extra)

2. Load Kakoune plugin

You can either:

- load `lf.kak` from your kakrc: `source path/to/lf.kak`
- put `lf.kak` in your autoloads directory `~/.config/kak/autoload/`

3. Add this snippet to lf config file: `~/.config/lf/lfrc`

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
		lf -remote "send $id map q :kak-exit-hook"

		echo "eval -client $kak_client set-option window lf_id $id" | kak -p "$kak_session"
	fi
}}

cmd kak-exit-hook ${{
	# rest lf_id in Kakoune
	echo "eval -client $kak_client set-option window lf_id ''" | kak -p "$kak_session"
	lf -remote "send $id quit"
}}

```

## Usage

Open lf with `:lf` command. Browse files as usual. Open files with `l` key.

## TODO

Check out [GH project](https://github.com/TeddyDD/kakoune-lf/projects/)

