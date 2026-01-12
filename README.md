# Neovim Configuration Guide

This document provides a reference for the external system requirements and the keyboard shortcuts (keymaps) defined in the configuration.

## 🛠 System Requirements (External Dependencies)

These tools must be installed on your operating system (Windows, macOS, or Linux) for the plugins to function correctly.

| Dependency | Purpose | Criticality |
| :--- | :--- | :--- |
| **Git** | Required to download plugins and update parsers. | 🔴 Critical |
| **Ripgrep** (`rg`) | Required by **Telescope** for the "Live Grep" feature (`<leader>fg`). Without it, text search inside files will fail. | 🔴 Critical |
| **C Compiler** (`gcc`, `clang`, or `zig`) | Required by **Treesitter** to compile language parsers (e.g., Python, C++, Lua) when running `:TSUpdate`. | 🔴 Critical |
| **Node.js & npm** | Required by **Mason** to install most LSP servers (TypeScript, HTML, CSS, Bash, JSON). | 🟠 High |
| **Nerd Font** | A patched font (e.g., *JetBrainsMono Nerd Font*). Required for **Neo-tree** icons and status lines. Must be set in your terminal emulator. | 🟡 Medium |
| **fd** (or `fd-find`) | Makes **Telescope** file search faster and respects `.gitignore`. | 🟢 Recommended |
| **Unzip / Tar / Gzip**| Required by **Mason** to extract downloaded language servers. | 🟢 Recommended |

---

## ⌨️ Keymaps (Hotkeys)

**Leader Key:** `<Space>`

### 🟢 General & Navigation

| Key | Action | Description |
| :--- | :--- | :--- |
| `jj` or `kk` | `<Esc>` | Exit Insert Mode quickly |
| `<Space> + w` | Save | Save current file |
| `Ctrl + h` | Window Left | Move focus to the left window |
| `Ctrl + l` | Window Right | Move focus to the right window |
| `Ctrl + j` | Window Down | Move focus to the window below |
| `Ctrl + k` | Window Up | Move focus to the window above |

### ⚠️ Diagnostics (Error Handling)

| Key | Action |
| :--- | :--- |
| `[d` | Jump to **Previous** error/diagnostic |
| `]d` | Jump to **Next** error/diagnostic |
| `<Space> + d` | Show full error message in a floating window |

### 📂 File Management (Neo-tree)

| Key | Action |
| :--- | :--- |
| `<Space> + e` | Toggle File Explorer (Neo-tree) |

### 🔍 Search (Telescope)

| Key | Action |
| :--- | :--- |
| `<Space> + ff` | **Find Files** (Search by filename) |
| `<Space> + fg` | **Live Grep** (Search text inside all files) |
| `<Space> + cr` | **LSP References** (Find where a symbol is used) |

### 💻 Terminal (ToggleTerm)

| Key | Context | Action |
| :--- | :--- | :--- |
| `Ctrl + \` | Normal/Term | **Toggle Terminal** window (float) |
| `jj` or `<Esc>` | Terminal | Exit terminal insert mode (to scroll/copy) |
| `Ctrl + h/j/k/l`| Terminal | Navigate out of terminal window to other buffers |

### 🐙 Git Integration

| Key | Plugin | Action |
| :--- | :--- | :--- |
| `<Space> + gd` | Diffview | **Open Diff** view |
| `<Space> + gh` | Diffview | Open **File History** |
| `<Space> + gc` | Diffview | **Close** Diff view |
| `<Space> + gl` | Flog | Open **Git Graph** (Log) |

### 🧠 LSP & Coding (Intellisense)

| Key | Action |
| :--- | :--- |
| `K` | **Hover Documentation** (Show info about symbol under cursor) |
| `gd` | **Go to Definition** |
| `gr` | **Go to References** |
| `<Space> + ca`| **Code Action** (Quick fixes) |
| `<Space> + rn`| **Rename** symbol (Refactoring) |

### 🤖 Autocompletion (nvim-cmp)

| Key | Action |
| :--- | :--- |
| `Ctrl + Space` | Trigger completion menu manually |
| `Enter` | **Confirm** selection |
| `Tab` | Select **Next** item |
| `Shift + Tab` | Select **Previous** item |
