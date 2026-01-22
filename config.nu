# config.nu
#
# Installed by:
# version = "0.109.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.color_config = {
    separator: default
    leading_trailing_space_bg: { attr: n }
    header: green_bold
    empty: blue
    bool: light_cyan
    int: default
    filesize: cyan
    duration: default
    datetime: purple
    range: default
    float: default
    string: default
    nothing: default
    binary: default
    cell-path: default
    row_index: green_bold
    record: default
    list: default
    closure: green_bold
    glob:cyan_bold
    block: default
    hints: dark_gray
    search_result: { bg: red fg: default }
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_yellow_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    shape_glob_interpolation: cyan_bold
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
    shape_garbage: {
        fg: default
        bg: red
        attr: b
    }
}

$env.PROMPT_COMMAND = {||
    let user = (match (whoami) {
        "u0_a398" => "oscar"
        $u => $u
    })
    let os = (match (sys host | get name | str downcase) {
        $n if ($n | str contains "windows") => "windows"
        $n if ($n | str contains "linux") => "linux"
        $n if ($n | str contains "sm-a546e") => "android"
        $n if ($n | str contains "darwin") or ($n | str contains "macos") => "macos"
        $n => $n
    })
    let cwd = (match $env.PWD {
        $p if $p == $nu.home-path => "~"
        $p if ($p | str starts-with $nu.home-path) => {
            $"~(($p | str substring ($nu.home-path | str length)..))"
        }
        $p => $p
    })
    let file_count = (ls | length)
    
    $"(ansi cyan)[($user)(ansi white)@(ansi cyan)($os)](ansi reset) -- (ansi green)[($cwd)](ansi reset) -- (ansi yellow)[($file_count) files](ansi reset)\n"
}

alias lh = ls -la
alias usr = cd ~
alias dw = cd ~/Downloads
alias docs = cd ~/Documents
alias tg = cd "~/Downloads/Telegram Desktop"
alias q = exit
alias yolo = claude --dangerously-skip-permissions
alias nv = nvim
alias . = start .
alias ii = start

def --env lf [] {
    let temp = (mktemp -t "lf-cwd.XXXXXX")
    ^lf -last-dir-path $temp
    let dir = (open $temp | str trim)
    rm $temp
    if ($dir != "") and ($dir != $env.PWD) {
        cd $dir
    }
}

def md [...name: string] {
  let dir = ($name | str join " ")
  mkdir $dir
  cd $dir
}

def --env fe [] {
    fzf -e | clip
}

def --env edal [] {
    nvim $nu.config-path
}

$env.config.show_banner = false
source ~/.zoxide.nu
