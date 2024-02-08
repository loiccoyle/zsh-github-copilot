# zsh-github-copilot

> A zsh plugin for GitHub Copilot

## ✔️ Setup

Requires the [GitHub CLI](https://github.com/cli/cli) with the [Copilot extension](https://github.com/github/gh-copilot) installed and configured.

## 🚀 Installation

### [antigen](https://github.com/zsh-users/antigen)

Add the following to your `.zshrc`:

```zsh
antigen bundle loiccoyle/zsh-github-copilot
```

### [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh)

Clone this repository into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`):

```zsh
git clone https://github.com/loiccoyle/zsh-github-copilot ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-github-copilot
```

Add the plugin to the list of plugins for Oh My Zsh to load (inside `~/.zshrc`):

```zsh
plugins=( 
    # other plugins...
    zsh-github-copilot
)
```

### [zinit](https://github.com/zdharma-continuum/zinit)

Add the following to your `.zshrc`:

```zsh
zinit light loiccoyle/zsh-github-copilot
```


### [zplug](https://github.com/zplug/zplug)

Add the following to your `.zshrc`:

```zsh
zplug "loiccoyle/zsh-github-copilot"
```

### [zpm](https://github.com/zpm-zsh/zpm)

Add the following to your `.zshrc`:

```zsh
zpm load loiccoyle/zsh-github-copilot
```

## 🧠Usage

Bind the **suggest** and/or **explain** widgets:

```zsh
bindkey '^\' zsh_gh_copilot_explain  # bind Ctrl+\ to explain
bindkey '^[\' zsh_gh_copilot_suggest  # bind Alt+\ to suggest
```

### Explanations

To get command explanations, write out the command in your prompt and hit your keybind.

### Suggestions

To get Copilot to suggest a command to fulfill a query, type out the query in your prompt and hit your suggest keybind.

## 🤩 Credit

This plugin draws from [`stefanheule/zsh-llm-suggestions`](https://github.com/stefanheule/zsh-llm-suggestions)
