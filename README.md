# Jose's dotfiles

This is a collection of my dotfiles and other configurations for my PCs. While the repository is named dotfiles, I also have scripts to do some basic setup of the PC and set options on new PCs to my liking (like MacOS options).

To setup a new computer (or update an existing one), run `./install.sh`.

# Structure

The dotfiles have been split up into folders to represent different responsibilities:
- `Alfred` contains the preferences for the Alfred app.
- `Brewfile` contains the brewfiles for installing homebrew applications.
- `Fonts` contains fonts that I prefer to use. Currently these must be installed manually.
- `backups` contains backups for previous dot files.
- `iTerm2` contains the preferences for iTerm.
- `scripts` contains the scripts that are run via `./install.sh`.
- `ssh` contains ssh configurations.
- `git` contains git configurations.
- `shell` contains configurations and dot files for the shell environment.

## References & sources

- Nerd fonts (icons): https://www.nerdfonts.com/font-downloads
- Font choosing flow: https://www.codingfont.com/

## Things to investigate adding
- API documentation search app (and Alfred integration). Potential options:
 - [Dash](https://kapeli.com/dash)
 - [DevDocs](https://devdocs.io/)
  - [Potential integration](https://github.com/yannickglt/alfred-devdocs)

