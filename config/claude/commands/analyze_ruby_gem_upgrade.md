You are tasked with analyzing Ruby gem upgrades between the current branch and main branch to identify potential compatibility issues and breaking changes.

## Usage Notes

- Always analyze the complete upgrade, not just the primary gem
- Include secondary dependency changes that might cause issues
- Prioritize critical business functionality (payment, order processing, etc.)
- Provide migration timeline recommendations
- Suggest rollback plan if issues are found
- We shouldn't run tests at this stage. Please ask if you want to know about potential test failures that happened in CI.

## Enhanced Analysis Process

### 1. Gem Change Detection
- Compare Gemfile.lock between current branch and main
- Identify all changed gems with version numbers
- Flag major version changes (high risk indicator)
- Extract dependency changes (added/removed dependencies)

### 2. Documentation Analysis

For each changed gem, fetch and analyze:
- UPGRADING.md
- MIGRATION.md
- CHANGELOG.md
- BREAKING_CHANGES.md
- GitHub releases page

Search for these breaking change keywords:
- "breaking change", "breaking changes", "BREAKING"
- "deprecated", "removed", "no longer supported"
- "incompatible", "migration required", "upgrade guide"
- "API changes", "method signature", "configuration changes"

### 3. Risk Assessment Framework

CRITICAL Risk Indicators:
- Major version changes (4.x → 5.x)
- HTTP client changes (httparty → faraday)
- Constructor signature changes (Class.new parameters)
- Error class renames (Error → ApiError)
- Configuration method changes

HIGH Risk Indicators:
- Minor version with breaking change keywords in changelog
- Method signature changes
- Dependency additions/removals
- Namespace changes

Usage Pattern Analysis:
- Search for variations of the gem name and public APIs of the gem throughout the codebase to analyze implementing code.

### 4. Configuration Impact Analysis
Check these files for potential impacts:
- config/initializers/
- Gemfile constraints
- Environment variable usage
- Service configuration classes

### 5. Output Format

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
- [ ] [Other things that may need to be updated (e.g. error handling, response parsing, etc.)]

### 6. Action Item Generation

Always provide specific, actionable next steps:
- Exact files that need updating
- Specific code patterns to change
- Testing recommendations
- Configuration updates needed
- Migration order if multiple gems affected

### 7. Follow-up Questions

Ask clarifying questions like:
- "Should I show you the specific code changes needed for [gem]?"
- "Would you like me to update the [specific file] for the new API?"
- "Should I check the test files for deprecated patterns?"

