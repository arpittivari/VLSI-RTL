# 15_Git

Store your source code, notes and testbenches here.

## 🚀 Basic Git Commands Cheat Sheet

Here is a quick reference guide to the most common Git commands used in daily development.

### 1. Setup & Initialization
- **Set your name:** `git config --global user.name "Your Name"`
- **Set your email:** `git config --global user.email "your.email@example.com"`
- **Initialize a new repository:** `git init`
- **Clone an existing repository:** `git clone <repository_url>`

### 2. Stage & Snapshot (Making Commits)
- **Check status:** `git status` (Shows modified files and what is staged for commit)
- **Stage a specific file:** `git add <file_name>`
- **Stage all changes:** `git add .`
- **Commit changes:** `git commit -m "Your descriptive commit message"`
- **View commit history:** `git log` or `git log --oneline` (for a compact view)

### 3. Branching & Merging
- **List all branches:** `git branch`
- **Create a new branch:** `git branch <branch_name>`
- **Switch to a branch:** `git checkout <branch_name>` or `git switch <branch_name>`
- **Create and switch to a new branch:** `git checkout -b <branch_name>`
- **Merge a branch into the active branch:** `git merge <branch_name>`

### 4. Share & Update (Working with Remotes)
- **Add a remote repository:** `git remote add origin <remote_url>`
- **Push your code to remote:** `git push origin <branch_name>` (Use `-u` for the first push: `git push -u origin main`)
- **Fetch and merge latest changes from remote:** `git pull origin <branch_name>`

### 5. Undoing Changes
- **Unstage a file (keep the edits):** `git reset <file_name>`
- **Discard changes in a modified file:** `git restore <file_name>` or `git checkout -- <file_name>`

---
*Tip: If you ever get stuck in the terminal while reading a `git log`, press the `q` key to exit back to the command line!*
