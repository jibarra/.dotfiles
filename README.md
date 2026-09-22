# Jose's dotfiles

This is a collection of my dotfiles and other configurations for my PCs. While the repository is named dotfiles, I also have scripts to do some basic setup of the PC and set options on new PCs to my liking (like MacOS options).

To setup a new computer (or update an existing one), run `./install.sh`.

# Structure

The dotfiles have been split up into folders to represent different responsibilities:

- `config/` contains configurations for different applications (e.g. git, shell, Alfred, Alacritty, etc.)
- `scripts/` contains the scripts that are run via `./install.sh`.
- `Brewfile/` contains the brewfiles for installing homebrew applications.
- `backups/` contains backups for previous dot files and configurations.

# Linux

This setup is currently geared toward macOS and has not been tested on Linux. Known limitations to reevaluate before using these dotfiles in a Linux environment:

- The overall structure and `./install.sh` setup flow assume macOS conventions and would need to be reevaluated.
- macOS-specific options (e.g. `defaults` settings) do not apply on Linux.
- `Brewfile/` assumes Homebrew; package installation would need a Linux equivalent.
- Allowed commands for AI agents should be reevaluated for safety, since some behave differently across platforms (e.g. `sed` differs between BSD/macOS and GNU/Linux).

# AI coding agents

Claude Code, opencode, and Codex share instructions from `config/ai_coding_harness/AGENTS.md` and skills from `config/ai_coding_harness/skills/`. Harness-specific agents, settings, hooks, and plugins remain in their own config folders.

`./install.sh` links `~/.claude/skills` and `~/.agents/skills` to the shared skills folder. Codex reads the latter; opencode discovers both automatically. The installer backs up any existing `~/.agents/skills` directory before replacing it with the link. Codex agent definitions in `config/codex/agents/` point to the shared Markdown prompts, so prompt edits take effect in every harness.

The Codex section of `scripts/link_dotfiles.sh` links shared instructions, hooks, and agents. It leaves `~/.codex/config.toml` entirely local and does not create or modify it. Configure personal settings and MCP servers there, then start a new Codex session to pick up instructions, skills, and agents. Codex may ask you to trust the notification hooks on first use.

## TODOs

- Investigate using environment variables for models.
- Create a script to generate agent details for Claude and opencode.
- Investigate and consider adding opencode plugins:
  - [opencode-plugin-simple-memory](https://github.com/ApplauseLab/opencode-plugin-simple-memory)
  - [plannotator](https://github.com/backnotprop/plannotator)
  - [openskills](https://github.com/numman-ali/openskills)
  - [opencode-handoff](https://github.com/joshuadavidthomas/opencode-handoff)

# References & sources

- Nerd fonts (icons): https://www.nerdfonts.com/font-downloads
- Font choosing flow: https://www.codingfont.com/
