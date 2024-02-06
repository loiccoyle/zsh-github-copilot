# zsh-github-copilot

> A zsh plugin for GitHub Copilot

## ✔️ Setup

Requires the [github cli](https://github.com/cli/cli) with the [copilot extension](https://github.com/github/gh-copilot) installed and configured.

## 🚀 Installation

### `zinit`

```zsh
zinit light loiccoyle/zsh-github-copilot
```

## 🧠Usage

Bind the suggest and/or explain widgets:
```zsh
bindkey '^o' zsh_gh_copilot_explain
bindkey '^p' zsh_gh_copilot_suggest
```

### Explanations

To get command explanations, write out the command in your prompt and hit your keybind.

### Suggestions

To get Copilot to suggest a command to fulfill a query, type out the query in your prompt and hit your suggest keybind.
