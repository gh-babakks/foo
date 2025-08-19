# foo

A simple tool to display open GitHub issues for the `gh-babakks/foo` repository.

## Features

- 📋 View open issues from the GitHub repository
- 🎯 Clean, formatted output showing issue details
- 🚀 Easy to use with npm scripts

## Usage

### View Open Issues

You can view the open issues using either of these methods:

```bash
# Using npm script (recommended)
npm run show-issues

# Or run directly with Node.js
node show-issues.js
```

### Output Format

The tool displays:
- Issue number and title
- Author information
- Creation date
- Number of comments
- Description preview
- Direct link to the issue

## Installation

1. Clone this repository
2. Install dependencies (if any):
   ```bash
   npm install
   ```
3. Run the show-issues command

## Requirements

- Node.js (version 12 or higher)
- Internet connection for live GitHub API access

## Example Output

```
📋 Open Issues for gh-babakks/foo

==================================================

1. Issue #12
   Title: foo
   Author: babakks
   Created: 7/30/2025
   Comments: 0
   Description: bar
   URL: https://github.com/gh-babakks/foo/issues/12

==================================================
Total open issues: 1
```