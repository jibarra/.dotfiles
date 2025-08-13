We're tasked with analyzing the Ruby gem upgrades that have occurred on the current branch
when compared to main.

We want to determine if the upgrades are compatible with the existing codebase
and if they introduce any breaking changes.

We should ensure the configuration or settings for the change are still compatible and
that any changes to deafults are handled.

We should ensure that any current usages aren't broken by changes in the gem version changes.

We should analyze the change log for all the gems updated in the lock file, not just the main gem updated.

You can assume that all tests in the codebase have passed in CI so we don't need to run tests locally.

$ARGUMENTS

