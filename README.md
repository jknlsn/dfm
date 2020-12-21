# dfm - Dot Files Manager

This is a super simple dot file manager. It works for me, your mileage may vary!

This automates how I want to manage my dotfiles in git, as seen here [https://gitlab.com/jknlsn/dotfiles](https://gitlab.com/jknlsn/dotfiles)

### Pre-requisites

Install xcode command line tools, homebrew and zinit.

1. `xcode-select --install`
2. `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. `sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"`

### Quick Start

After pre-requisites are installed add the following to the end of your `.zshrc` file. this will install DFM (Dot Files Manager) and you can then start using dfm to manage your dotfiles and brew installs.

```
zinit ice depth=1;
zinit light jknlsn/dfm
```

Pull the files down and configure your dotfiles repo, or create an empty repo.

```
git clone --bare git@gitlab.com:jknlsn/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ config core.bare false
git --git-dir=$HOME/.dotfiles/ config core.worktree $HOME
git --git-dir=$HOME/.dotfiles/ checkout -f
```

From now on can use `dfm` commands to install brew packages or to update the list of installed brew packages and sync it to this repo.

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

### Example workflow and usage

Find and install a brew package, for example the hotkey package [skhd](https://github.com/koekeishiya/skhd) or
[yabai](https://github.com/koekeishiya/yabai). Customise the config as suits, then decide to stick with it and want to store as part of your dotfiles.

```
brew install koekeishiya/formulae/skhd
code-insiders .skhdrc
dfm create .skhdrc
dfm update
```

That's it you're done! You will see a similar message to the below from git confirming your file updates.

```
Updating Homebrew...
[master 1adea30] Update dotfiles and installs
 1 file changed, 2 insertions(+)
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 8 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 360 bytes | 360.00 KiB/s, done.
Total 3 (delta 2), reused 0 (delta 0)
To gitlab.com:jknlsn/dotfiles.git
   65bd87d..1adea30  master -> master
```

### Notes

This is a **simple** dot files manager. It does not control your whole system, so for packages like yabai which require SIP modifications and skhd which requires accessibility permissions, there will still be manual steps before you are 100% up and running, but this will get you pretty close.
