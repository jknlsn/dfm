#!/usr/bin/env zsh
# -*- mode: sh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-

# Copyright (c) 2020 Jake Nelson

# An example of type-agnostic script/function, i.e.: the file can be run as a +x
# script or as an autoload function.

# Set the base and typically useful options
emulate -LR zsh
setopt extendedglob warncreateglobal typesetsilent noshortloops rcquotes

# Run as script? ZSH_SCRIPT is a Zsh 5.3 addition
if [[ $0 != example-script || -n $ZSH_SCRIPT ]]; then
    # Handle $0 according to the Zsh Plugin Standard:
    # http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
    0=${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}
    0=${${(M)0##/*}:-$PWD/$0}

    # Such global variable is expected to be typeset'd -g in the plugin.zsh
    # file. Here it's restored in case of the function being run as a script.
    typeset -gA Plugins
    Plugins[DOTFILES_DIR]=${0:h}

    # In case of the script using other scripts from the plugin, either set up
    # $fpath and autoload, or add the directory to $PATH.
    fpath+=( $Plugins[DOTFILES_DIR] )
    autoload …

    # OR
    path+=( $Plugins[DOTFILES_DIR] )
fi

# The script/function contents possibly using $Plugins[DOTFILES_DIR] …
# …

# Use alternate marks [[[ and ]]] as the original ones can confuse nested
# substitutions, e.g.: ${${${VAR}}}

# vim:ft=zsh:tw=80:sw=4:sts=4:et:foldmarker=[[[,]]]


function update(){
    # Check git status update
    # Check brewfile for changes
    local message="Update dotfiles and installs"
    
    brew bundle dump --file ~/.Brewfile.temp
    local output=$(diff ~/.Brewfile ~/.Brewfile.temp)
    rm ~/.Brewfile.temp
    if [[ -z $output ]]; then
        echo "No changes"
    else
        git --git-dir=$HOME/.dotfiles/ add ~/.Brewfile
        rm ~/.Brewfile
        brew bundle dump --global
        # Remove newlines and turn < > into - +
        message=$(echo $output | tail -n +2 | sed -e :a -e '$!N;s/\n/|/;ta' | sed 's/|[a-zA-Z0-9]*|/ /g' | sed 's/</-/g;s/>/+/g')
        echo $message
    fi

    git --git-dir=$HOME/.dotfiles/ commit -m $message -a
    git --git-dir=$HOME/.dotfiles/ push
}

function add(){
    git --git-dir=$HOME/.dotfiles/ add $1
    git --git-dir=$HOME/.dotfiles/ commit -m "Added $1"
    git --git-dir=$HOME/.dotfiles/ push
}

function install(){
    brew bundle install --global
}

function status(){
    git --git-dir=$HOME/.dotfiles/ status
    brew bundle dump --file ~/.Brewfile.temp
    local output=$(diff ~/.Brewfile ~/.Brewfile.temp)
    rm ~/.Brewfile.temp
    if [[ -z $output ]]; then
        echo "No changes"
    else
        echo $output | sed 's/</-/g;s/>/+/g'
    fi
}

function help(){
    echo "
Usage: dfm [command]
    [ u | update | -u | --update ]
    [ i | install | -i | --install ]
    [ a | add | -a | --add ] [ filename ]
    [ s | status | -s | --status ]
    [ h | help | -h | --help ]

    update:     push changes to brew installs or watched files to git
    install:    install from brew config file
    add:        add new dotfile
    status:     show changes
    help:       display manual
    "
}

case "$1" in
    u | update | -u | --update )
        update
        ;;
    i | install | -i | --install )
        install
        ;;
    s | status | -s | --status )
        status
        ;;
    a | add | -a | --add )
        if [[ $# < 2 ]];
        then
            echo "Please specify an argument i.e. \ndfm -c .filename"
        else
            create $2
            # create $@
        fi;
        ;;
    h | help | -h | --help )
        help
        ;;
esac