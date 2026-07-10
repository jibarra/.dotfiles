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

# Linux

This setup is currently geared toward macOS and has not been tested on Linux. Known limitations to reevaluate before using these dotfiles in a Linux environment:

- The overall structure and `./install.sh` setup flow assume macOS conventions and would need to be reevaluated.
- macOS-specific options (e.g. `defaults` settings) do not apply on Linux.
- `Brewfile/` assumes Homebrew; package installation would need a Linux equivalent.
- Allowed commands for AI agents should be reevaluated for safety, since some behave differently across platforms (e.g. `sed` differs between BSD/macOS and GNU/Linux).

# AI coding agents

Note that I have separate configs for AI coding agents (e.g. Claude and opencode). Since harness instructions aren't standardized, I've chosen to keep that stored separately as well. For example, Claude has its own setup for agents, skills, etc. For now, I'm dependent on other coding agents reading this but if they become more standardized, it can be generalized into a single source directory.

## TODOs

- Investigate using environment variables for models.
- Create a script to generate agent details for Claude and opencode.
- Investigate and consider adding opencode plugins:
  - [opencode-plugin-simple-memory](https://github.com/ApplauseLab/opencode-plugin-simple-memory)
  - [plannotator](https://github.com/backnotprop/plannotator)
  - [openskills](https://github.com/numman-ali/openskills)
  - [opencode-handoff](https://github.com/joshuadavidthomas/opencode-handoff)
- Add homebrew to path during install so it runs all together
- Install fonts when running install script
- Accept the Xcode terms during the install script to make the install smoother

# References & sources

- Nerd fonts (icons): https://www.nerdfonts.com/font-downloads
- Font choosing flow: https://www.codingfont.com/

