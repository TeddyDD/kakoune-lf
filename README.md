# Kakoune lf

# Deprecated

Use [kaktree](https://github.com/andreyorst/kaktree)

---

kakoune-lf is plugin for [Kakoune] text editor. It integrates [lf] file manager
as sidebar file browser.

![screenshot](screen.png)

## Installation

You have to have lf executable in PATH.

### Dependencies

**Only last stable versions of Kakoune and lf are supported**

- [lf][lf] file manager

### Installation

1. Install Kakoune plugin. Any of the following methods will do

- use [plug.kak] plugin manager
- load `lf.kak` from your kakrc: `source path/to/lf.kak`
- put `lf.kak` in your autoloads directory `~/.config/kak/autoload/`

## Usage

### Kakoune commands

- Open/close lf with `:lf` command.

- `:lf-follow` opens directory containing current buffer (or Kakoune's CWD if
buffer is not existing file) in runing lf instance

- `:lf-sync-cwd` opens Kakoune CWD in runing lf instance

### lf keys

- up / down <kbd>j</kbd> <kbd>k</kbd>
- parent directory <kbd>h</kbd>
- open file under cursor (and selected files if any) in Kakoune <kbd>l</kbd>
- select file <kbd>space</kbd>
- unselect all files <kbd>u</kbd>
- enter command <kbd>:</kbd>
- quit <kbd>q</kbd>

See lf documentation for more.

### lf commands

- `:lf-sync-cwd` change Kakoune's CWD to currently open directory

## Kakoune options

- `lf_terminal_cmd` name of Kakoune command that will spawn terminal/tmux
  window with lf. It *must* expose `$kak_session` and `$kak_client` environmental
  variables. By default it uses `terminal` (build-in) command. See `lf-spawn-new`
  form `rc/lf.kak` for reference.
- `lf_follow` option to enable/disable changing lf path on Kakoune buffer change.
- `lf_openables` list of regexes that has to match mimetype of file opened from lf.
  This prevents opening binary files by accident.

## TODO

Check out [GH project](https://github.com/TeddyDD/kakoune-lf/projects/)

## Changelog

- 0.1 2018-09-07:
    - initial release
    - Kakoune v2018.09.04
- 0.2 2019-02-02:
    - **Kakoune v2019.01.20**
    - **lf r9**
    - _CHANGE_ update README to new format
    - _CHANGE_ lf works as a toggle
    - __CHANGE__ reduce amount of configuration that has to be pasted in
    `lfrc` (**breaking** requires manual update of `lfrc`)
    - __CHANGE__ to new repository layout (**breaking** update path in
    `kakrc`)
    - _ADD_ `lf_terminal_cmd` option for custom spawn command
- 0.3 2019-02-07:
    - _CHANGE_ add hooks to `lf` group
    - _ADD_ editorconfig
    - _CHANGE_ format files in repo with editorconfig
    - _ADD_ opening multiple files at once
    - _FIX_ open paths with spaces
- 0.9 2019-02-12:
    - **lf r10**
    - __CHANGE__ move all configuration to Kakoune (**breaking** requires
      manual update of `lfrc`). You can use this plugin without modyfing `lfrc`
    - _CHANGE_ remove `hatch_terminal` dependency, use built-in `terminal` command by default
    - _ADD_ display number of opened files in lf status line
    - _ADD_ `:lf-follow` command and `lf_follow` option that look for
      current opened buffer in lf
    - _ADD_ mimetype check to avoid opening binary files
    - _ADD_ command for synchronizing CWD (`lf-cwd-sync`)

[lf]: https://github.com/gokcehan/lf
[Kakoune]: http://kakoune.org/
[Kakoune-extra]: https://github.com/lenormf/kakoune-extra
[plug.kak]: https://github.com/andreyorst/plug.kak

