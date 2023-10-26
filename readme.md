## dotfiles
System settings, configuration files and apps for MacOS.

## Installation

Sorry, but there's no fully automated installation script that could be run on a fresh MacOS installation and procude a full-blown setup in a one shot. I tried to implement it in a past, but it turns to be overcomplicated. It's better to copy and run a piece of code and validate the outcome.

## Terminal and shell

- [tmux](https://github.com/tmux/tmux) running inside [iTerm2](https://iterm2.com/)
- [zsh](https://github.com/zsh-users/zsh) + [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) plugins managed via [antigen](https://github.com/zsh-users/antigen)
- Configuration is kept in [.zshenv](zsh/.zshenv) and [.zshrc](zsh/.zshrc) files

## Text editors
- [vim](https://www.vim.org/) as an `$EDITOR`. Vim configuration lives in a dedicated repo. See [samoshkin/dotvim](https://github.com/samoshkin/dotvim) repo.
- [vscode](https://code.visualstudio.com/), if Vim is just too hardcore for you. **NOTE**: vscode configuration is TBD.

## File system

- [nnn](https://github.com/jarun/nnn) as a single-panel console file manager. Altenatively, if you prefer two-panel file manager, use [midnight commander](https://midnight-commander.org)
- [osxfuse](https://osxfuse.github.io/), brings support for FUSE (file systems in a user space). FUSE allows to mount and view archives, remote file systems over SSH, not supported file systems as a directory in your local filesystem. Use [ntfs-3g](https://github.com/osxfuse/osxfuse/wiki/NTFS-3G) to mount [NTFS](https://en.wikipedia.org/wiki/NTFS) volumes. Use [macfusion-ng](https://github.com/macfusion-ng/macfusion2) or [sshfs](https://github.com/libfuse/sshfs) to mount remote file systems over SSH or FTPS.
- [archivemount](https://linux.die.net/man/1/archivemount), mounts an archive for access as a directory on a file system. Requires [osxfuse](https://osxfuse.github.io/) to work.

## Terminal applications

- [ripgrep](https://github.com/BurntSushi/ripgrep) for full-text search, modern replacement for `grep`.
- [fd](https://github.com/sharkdp/fd) to find files on a file system, modern replacement for `find`.
- [exa](https://github.com/ogham/exa) to list files in a directory, modern replacement for `ls`.
- up-to-date version of GNU utils (e.g. `sed`, `tar`, `grep`, `find`, etc.) installed in place of older versions shipped natively with MacOS.
- [fzf](https://github.com/junegunn/fzf) to fuzzy find files. It's versatile enough and not limited to files only scenario. You can pipe pretty much anything through it and get  a nice fuzzy selector interface and apply arbitrary action to the selected item or items. Examples are text search matches, brew formulas, npm packages, git commits, git branches, etc.
- [atool](https://savannah.nongnu.org/projects/atool/) to manage archives of various types. `zip` and `unzip` commands to work with zip archives.
- `rifle` command from [ranger](https://github.com/ranger/ranger) file manager is used as a smart file opener instead of the stock `open` command. You can configure which application handles which file type, and open a file through it.
- [bat](https://github.com/sharkdp/bat), same to `cat` but with syntax highlighting.
- [rupa/z](https://github.com/rupa/z) tracks your most used directories based on 'frecency', and lets you jump around without having to type fully qualified directory path.
- Patched version of `DroidSansMono` font from [NerdFonts](https://www.nerdfonts.com/) is used in a terminal. It contains a large collection of icons combined from different sources (from font awesome, devicons, octicons, etc).
- [direnv](https://direnv.net/) to load directory-local `.envrc` and read environment variables. It's used to load 12factor apps environment variables, create per-project isolated development environments, or load secrets for deployment.
- [curl](https://curl.se/) and [wget](https://www.gnu.org/software/wget/) to download files
- [htop](https://htop.dev/) for interactive process management, [fkill-cli](https://github.com/sindresorhus/fkill-cli) to fuzzy find process by name and kill it.
- [rsync](https://linux.die.net/man/1/rsync) to copy files and directories when stock `cp` is just not enough.
- [httpie](https://httpie.io/), command-line HTTP client for the API era with JSON support, syntax highlighting. More advanced alternative to `curl` or `wget`.
- [mptre/yank](https://github.com/mptre/yank) to yank terminal output to clipboard through a simple selection interface.
- [antonmedv/fx](https://github.com/antonmedv/fx), command line JSON processing and interacive viewer tool. Alternatively, use [jq](https://stedolan.github.io/jq/), lightweight and flexible command-line JSON processor, without interactive interface.
- [ncdu](https://dev.yorhel.nl/ncdu), ncurses disk usage program.
- [httrack](https://www.httrack.com/) to copy whole website for offline viewing.
- [nmap](https://nmap.org/) to scan nodes on a network, probe open ports and check remote running apps.
- [bandwhich](https://github.com/imsnif/bandwhich), CLI utility for displaying current network utilization by process, connection and remote IP/hostname.
- [up](https://github.com/akavel/up), tool for writing Linux pipes with instant live preview.
- [itchyny/bed](https://github.com/itchyny/bed), binary/hex editor written in Go. Alternatively, use `xxd`, `hexdump` or `od` to view files in a binary/hex mode.
- [mediainfo](https://mediaarea.net/en/MediaInfo), a unified display of technical and tag data for video and audio files.


## GUI applications

Not every app in this list is managed and installed via scripts in this repo. Consider it as just a dump of GUI apps I'm using, some of them are installed via `brew cask`, whereas other through `App Store`. I omit most evident apps like browsers, messengers, etc.

- [Microsoft Todo](https://to-do.microsoft.com/tasks/), task management app from Microsoft.
- [amethyst](https://ianyh.com/amethyst/) is a tiling window manager for MacOS, so you don't need to constantly arrange and resize windows on a screen(s) on your own.
- [macpass](https://macpassapp.org/) is a password manager, a KeePass compatible port for MacOS.
- [karabiner-elements](https://karabiner-elements.pqrs.org/) to remap keys system-wide, [key-codes](https://manytricks.com/keycodes/) to inspect key codes on press
- [postman](https://www.postman.com/) to build and talk to HTTP APIs
- [virtualbox](https://www.virtualbox.org/) and [docker](https://www.docker.com/) for virtualization
- [keepingyourawake](https://github.com/newmarcel/KeepingYouAwake) to keep you Mac from sleep. Similar to `caffeine` or `amphetamine`.
- [speedcrunch](http://speedcrunch.org/) is a calculator app
- [vlc](https://www.videolan.org/vlc/index.html) is a video player
- [zim](https://zim-wiki.org/) is a personal wiki. Zim is a notepad like desktop application that is inspired by the way people use wikis. I use it to keep miriad of notes and as a knowledge base. It has non-native UI on MacOS, but nevertheless it's very useful tool for keeping large amount of notes, and I hardly can find a replacement for it.
- [qbittorrent](https://www.qbittorrent.org/), a cross-platform free and open source BitTorrent client.
- [bandwidth+](https://apps.apple.com/us/app/bandwidth/id490461369), tracks network usage including upload and download speed, and shows small icon in the MacOS menu bar at the top.
- [Microsoft Remote Desktop](https://apps.apple.com/us/app/microsoft-remote-desktop/id1295203466), if you need to connect to another computer over proprietary RDP protocol.
- [monosnap](https://monosnap.com/) to make screenshots and upload them to various cloud storages.


## Most common commands and aliases

```
# Open files using "rifle"
# See https://github.com/ranger/ranger
alias o='rifle'

# Edit files using whatever $EDITOR
alias e="$EDITOR"
alias E="editor_in_split_pane"


# Long listing like "ls -la"
alias l='exa -la --group-directories-first --time-style long-iso --color-scale'

# Extract any archive with "x" alias using "atool"
alias x="atool -x"

# "nnn" file manager
$ n

" jump around file system, smart cd to directory
$ z

# Search with ripgrep+fzf with live query reload and live file/match preview
$ rgi

# Open fuzzy finder, select file and open in an $EDITOR
$ fe
```

For a complete list of extra commands or aliases, see scripts inside [zsh](./zsh) directory.


## Working with Git

Initially I was using Git extras and aliases from [prezto git module](https://github.com/sorin-ionescu/prezto/tree/master/modules/git), but after some time I noticed I'm using only a small fraction of features it provides in my everyday work. So I removed it and wrote most commonly used commands on my own. See [git.sh](zsh/scripts/git.sh).

In addition to working with Git on a command line, I use Vim (with [vim-fugitive](https://github.com/tpope/vim-fugitive) plugin) as a complement tool for viewing diffs, files to be commited, logs, exploring internal Git object database, extracting a snapshot of any file at any revision.

[Diffmerge](https://sourcegear.com/diffmerge/) is used as a Git difftool or mergetool. I rarely use [sourcetree](https://www.sourcetreeapp.com/) app, maybe only to explore complex git log histories.

[git-fuzzy](https://www.sourcetreeapp.com/) pipes status, log, diff and other Git commands through [fzf](https://github.com/junegunn/fzf) resulting in a nice selector interface for Git objects with a live preview on the right side.

[delta](https://github.com/junegunn/fzf) is a viewer for git and diff output. Given delta, you can look at and review some simple diffs in a terminal. It comes with syntax highlihgting, line numbering, side-by-side view, within-line modifications, and other features.

To give an example, here is a bunch of commands I use to review PRs. It's mostly a terminal-oriented experience. It's all about exploring differences between `<pr>` and `<upstream>` revisions, or between `<pr>` and `$(git merge-based pr upstream)`.

```bash
# Explore a difference between <pr> and <upstream>
git checkout <upstream>
git pull

# View a only a list of affected files. `gds` is for "git diff --stat"
# Commit range refers to commit reachable from <origin/pr>, but not reachable from <upstream>
# Basically that means all commits unique to a pull request
gds <upstream>..<origin/pr>

# view commits in PR, and patch for each commit
# glo = git log --oneline
# gfl = git fuzzy log
glo <upstream>..<origin/pr>
gfl <upstream>..<origin/pr>
:Git log <upstream>..<origin/pr> # vim command

# view list of affected files and complete diff for each file (not a commit's patch)
# gfd = git fuzzy diff
# gdt = git difftool (opens Vim or Diffmerge as a difftool)
gfd <upstream>..<origin/pr>
gdt <upstream>..<origin/pr>

# You might also open given file at a given revision, and probably blame it
# `ge` is similar to "git show", but open file's snapshot in a Vim
ge <rev>:<file>
git show <rev>:<file_or_dir>
:Git blame # vim command

# View affected files and a complete diff, and then open selected files in a Vim
$ git checkout <origin/pr>
$ REVIEW_UPSTREAM=<upstream> git_review_pr
# Then use :GdiffUpstream to enter a diff mode between `<pr>` vs `$(merge-base <pr> <upstream>)`
:GdiffUpstream
```

## Development tools

- [node](https://nodejs.org/en/) and [nvm](https://github.com/nvm-sh/nvm)
- [python3](https://www.python.org/) and [pyenv](https://github.com/pyenv/pyenv)
- [http-server](https://github.com/http-party/http-server) to serve static files in ad-hoc development and testing scenarios
- [universal-ctags](https://github.com/universal-ctags/ctags), programming tool that generates an index (or tag) file of names found in source and header files of various programming languages to aid code comprehension. Symbols are parsed using regular expressions.
