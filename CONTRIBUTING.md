# Contributing to mdview.nvim

First off, thank you for considering contributing to mdview.nvim! It's people like you that make mdview.nvim such a great tool.

Following these guidelines helps to communicate that you respect the time of the developers managing and developing this open source project. In return, they should reciprocate that respect in addressing your issue, assessing changes, and helping you finalize your pull requests.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Your First Code Contribution](#your-first-code-contribution)
  - [Pull Requests](#pull-requests)
- [Style Guides](#style-guides)
  - [Git Commit Messages](#git-commit-messages)
  - [Coding Style](#coding-style)
- [Setting Up Your Development Environment](#setting-up-your-development-environment)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by the [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior.

## How Can I Contribute?

### Reporting Bugs

This section should guide users on how to report a bug. Before submitting a bug report, please check the issue tracker to see if the bug has already been reported.

When you are creating a bug report, please include as many details as possible. Fill out the required template, the information it asks for helps us resolve issues faster.

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

### Suggesting Enhancements

This section should guide users on how to suggest an enhancement.

- **Use a clear and descriptive title** for the issue to identify the suggestion.
- **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
- **Explain why this enhancement would be useful** to most users.

### Your First Code Contribution

Unsure where to begin contributing to mdview.nvim? You can start by looking for `good first issue` or `help wanted` labels in the issue tracker.

### Pull Requests

The process described here has several goals:

- Maintain code quality
- Fix problems that are important to users
- Engage the community in working toward the best possible mdview.nvim

Please follow these steps to have your contribution considered by the maintainers:

1.  Fork the repository and create your branch from `main`.
2.  If you've added code that should be tested, add tests.
3.  If you've changed APIs, update the documentation.
4.  Ensure the test suite passes.
5.  Make sure your code lints.
6.  Issue that pull request!

## Style Guides

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature").
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...").
- Limit the first line to 72 characters or less.
- Reference issues and pull requests liberally after the first line.

### Coding Style

Regarding code formatting, we use `luacheck` for Lua and `prettier` for JavaScript. Please run them on your code before committing.

## Setting Up Your Development Environment

To set up a local development environment, you'll need to have the following installed:

- [Node.js](https://nodejs.org/)
- [Bun](https://bun.sh/)
- [Neovim](https://neovim.io/)
- [pnpm](https://pnpm.io/)

Once you have the prerequisites, you can set up the project with the following commands:

```bash
# Install dependencies
pnpm install

# Run the development server
bun run dev
```

## Community

If you want to get in touch with the team and the community, you can find us on the issue tracker.
