---
name: analyze_ruby_gem_upgrade
description: Analyze a Ruby gem upgrade on the current branch vs main to surface breaking changes, risk level, and required code updates. Use when the user asks to review/audit a Gemfile.lock bump, plan a gem migration, or assess upgrade risk before merging.
---

# Analyze Ruby gem upgrade

Analyze Ruby gem upgrades between the current branch and `main` to identify potential compatibility issues and breaking changes.

## Usage notes

- Always analyze the complete upgrade, not just the primary gem
- Include secondary dependency changes that might cause issues
- Prioritize critical business functionality (payment, order processing, etc.)
- Provide migration timeline recommendations
- Suggest a rollback plan if issues are found
- Do not run tests at this stage. Ask the user if they want you to look at CI test failures instead.

## Analysis process

### 1. Gem change detection
- Compare `Gemfile.lock` between the current branch and `main`
- Identify all changed gems with version numbers
- Flag major version changes (high-risk indicator)
- Extract dependency changes (added/removed dependencies)

### 2. Documentation analysis

For each changed gem, fetch and analyze:
- `UPGRADING.md`
- `MIGRATION.md`
- `CHANGELOG.md`
- `BREAKING_CHANGES.md`
- GitHub releases page

Search for these breaking-change keywords:
- "breaking change", "breaking changes", "BREAKING"
- "deprecated", "removed", "no longer supported"
- "incompatible", "migration required", "upgrade guide"
- "API changes", "method signature", "configuration changes"

### 3. Risk assessment framework

CRITICAL risk indicators:
- Major version changes (4.x → 5.x)
- HTTP client changes (httparty → faraday)
- Constructor signature changes (`Class.new` parameters)
- Error class renames (`Error` → `ApiError`)
- Configuration method changes

HIGH risk indicators:
- Minor version with breaking-change keywords in the changelog
- Method signature changes
- Dependency additions/removals
- Namespace changes

Usage pattern analysis:
- Search for variations of the gem name and its public APIs throughout the codebase to analyze implementing code.

### 4. Configuration impact analysis

Check these locations for potential impacts:
- `config/initializers/`
- `Gemfile` constraints
- Environment variable usage
- Service configuration classes

### 5. Output format

Provide analysis in this structure:

🔍 RUBY GEM UPGRADE ANALYSIS
📊 Version Changes: [list all changed gems with versions]

For each changed gem:
🚨 RISK LEVEL: [CRITICAL|HIGH|MEDIUM|LOW]

📋 Changes Detected:
- Version: old → new
- Dependencies: [list changes]
- Major version change: [yes/no]

⚠️ Breaking Changes Found:
- [List specific breaking changes from docs]
- [API method changes detected]
- [Configuration changes needed]

🔍 Codebase Impact:
- Files using this gem: [count]
- Potential breaking usage: [list files]

📝 Required Actions:
- [ ] Update configuration in [file]
- [ ] Update API calls in [files]
- [ ] Update tests for new API
- [ ] [Other things that may need updating (error handling, response parsing, etc.)]

### 6. Action item generation

Always provide specific, actionable next steps:
- Exact files that need updating
- Specific code patterns to change
- Testing recommendations
- Configuration updates needed
- Migration order if multiple gems are affected

### 7. Follow-up questions

Ask clarifying questions like:
- "Should I show you the specific code changes needed for [gem]?"
- "Would you like me to update [specific file] for the new API?"
- "Should I check the test files for deprecated patterns?"
