#!/bin/bash

# Script to lint modified Ruby files with RuboCop
# Called by Claude Code post_tool_use hook

# Only run for file modification tools
if [[ ! "$CLAUDE_TOOL_NAME" =~ ^(Edit|MultiEdit|Write)$ ]]; then
    exit 0
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Not in a git repository, skipping Ruby linting" >&2
    exit 0
fi

# Check if Gemfile exists (required for bundle exec)
if [ ! -f Gemfile ]; then
    echo "No Gemfile found, skipping Ruby linting" >&2
    exit 0
fi

# Get modified Ruby files
modified_ruby_files=$(git diff --name-only --diff-filter=AM | grep '\.rb$')

if [ -z "$modified_ruby_files" ]; then
    echo "No modified Ruby files found" >&2
    exit 0
fi

echo "Running RuboCop on modified Ruby files: $modified_ruby_files" >&2

# Run RuboCop with autocorrect on the modified files
echo "$modified_ruby_files" | xargs bundle exec rubocop --autocorrect

exit_code=$?
if [ $exit_code -eq 0 ]; then
    echo "RuboCop completed successfully" >&2
else
    echo "RuboCop finished with exit code $exit_code" >&2
fi

exit $exit_code
