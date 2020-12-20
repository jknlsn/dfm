# dfm - Dot Files Manager

## works for me ymmv

This is a super simple dot file manager.

Automates how I want to manage my dotfiles in git, as seen here [https://gitlab.com/jknlsn/dotfiles](https://gitlab.com/jknlsn/dotfiles)

### Usage

dfm [command]
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
