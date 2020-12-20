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
    rm ~/.Brewfile
    brew bundle dump --global
    dotfiles add ~/.Brewfile
    dotfiles commit -m "Update dotfiles and installs" -a
    dotfiles push
}

function create(){

    # arr="$@"
    # msg="Added "

    # echo $arr

    # for (( i=1; i < ${#arr[@]} ; i++ )); do
        # dotfiles add $arr[$i]
        # msg+=arr[$i]
        # echo $arr[$i]
    # done

    # if [[ msg != "Added " ]];
    # then
    #     dotfiles commit -m $msg
    #     dotfiles push
    # fi

    dotfiles add $1
    dotfiles commit -m "Added $1"
    dotfiles push
}

function install(){
    brew bundle install --global
}

function help(){
    echo "
Usage: dotfiles [command]
    [ u | update | -u | --update ]
    [ i | install | -i | --install ]
    [ c | create | -c | --create ] [ filename ]
    [ h | help | -h | --help ]

    update:     push changes to brew installs or watched files to git
    install:    install from brew config file
    create:     add new dotfile and push
    help:       display manual

Any other arguments fall through to git, i.e. dotfiles status

Use 'git --help' to access general git help.
    "
}

if [[ $argv = "add ." ]]; then
    echo "Nope, you don't want to add all files."
else

    case "$1" in
        u | update | -u | --update )
            update
            ;;
        i | install | -i | --install )
            install
            ;;
        c | create | -c | --create )
            if [[ $# < 2 ]];
            then
                echo "Please specify an argument i.e. \ndotfiles -c .filename"
            else
                create $2
                # create $@
            fi;
            ;;
        h | help | -h | --help )
            help
            ;;
        * )
            /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv
            ;;
    esac

fi