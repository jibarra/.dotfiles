# Jose's dotfiles

This is a collection of my dotfiles and other configurations for my PCs. While the repository is named dotfiles, I also have scripts to do some basic setup of the PC and set options on new PCs to my liking (like MacOS options).

To setup a new computer (or update an existing one), run `./install.sh`.

# Structure

The dotfiles have been split up into folders to represent different responsibilities:

- `config/` contains configurations for different applications (e.g. git, shell, Alfred, Alacritty, etc.)
- `scripts/` contains the scripts that are run via `./install.sh`.
- `Brewfile/` contains the brewfiles for installing homebrew applications.
- `Fonts/` contains fonts that I prefer to use. Currently these must be installed manually.
- `backups/` contains backups for previous dot files and configurations.

# AI coding agents

Note that I have separate configs for AI coding agents (e.g. Claude and opencode). Since harness instructions aren't standardized, I've chosen to keep that stored separately as well. For example, Claude has its own setup for agents, skills, etc. For now, I'm dependent on other coding agents reading this but if they become more standardized, it can be generalized into a single source directory.

## opencode plugins to investigate

Plugins to investigate and consider adding:

- [opencode-plugin-simple-memory](https://github.com/ApplauseLab/opencode-plugin-simple-memory)
- [plannotator](https://github.com/backnotprop/plannotator)
- [openskills](https://github.com/numman-ali/openskills)
- [opencode-notify](https://github.com/kdcokenny/opencode-notify)
- [opencode-handoff](https://github.com/joshuadavidthomas/opencode-handoff)

# References & sources

- Nerd fonts (icons): https://www.nerdfonts.com/font-downloads
- Font choosing flow: https://www.codingfont.com/

