# dfm - Dot Files Manager

## **works for me ymmv**

This is a super simple dot file manager.

Automates how I want to manage my dotfiles in git, as seen here [https://gitlab.com/jknlsn/dotfiles](https://gitlab.com/jknlsn/dotfiles)

### Pre-requisites

Install xcode command line tools, homebrew and zinit.

1. `xcode-select --install`
2. `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. `sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"`

Pull the files down and configure your dotfiles repo, or create an empty repo.

```
git clone --bare git@gitlab.com:jknlsn/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ config core.bare false
git --git-dir=$HOME/.dotfiles/ config core.worktree $HOME
git --git-dir=$HOME/.dotfiles/ checkout -f
```

Source the zshrc config.
`source .zshrc`

From now on can use `dfm` commands to install brew packages or to update the list of installed brew packages and sync it to this repo.

### Quick Start

After pre-requisites are installed add the following to the end of your `.zshrc` file. this will install DFM (Dot Files Manager) and you can then start using dfm to manage your dotfiles and brew installs.

```
zinit ice depth=1;
zinit light jknlsn/dfm
```

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
```

```
brew install jesseduffield/lazygit/lazygit
```

That's it you're done! You will see a similar message from git confirming your file updates.

### Notes

This is a **simple** dot files manager. It does not control your whole system, so for packages like yabai which require SIP modifications and skhd which requires accessibility permissions, there will still be manual steps before you are 100% up and running, but this will get you pretty close.
