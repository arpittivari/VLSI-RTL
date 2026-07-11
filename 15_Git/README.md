# 15_Git — Git & GitHub Notes for VLSI RTL Design

Git is a distributed version control system used to track changes in source code, RTL designs, testbenches, scripts, constraints, documentation, and other engineering files.

For this VLSI RTL journey, Git will track the development of:

- Verilog RTL (`.v`)
- SystemVerilog RTL and testbenches (`.sv`)
- Testbenches
- ModelSim scripts (`.do`)
- Python automation scripts
- Yosys synthesis scripts
- OpenSTA timing scripts
- SDC constraints
- Documentation and notes

Repository:

https://github.com/arpittivari/VLSI-RTL

---

# 1. Git vs GitHub

Git and GitHub are not the same thing.

Git:
- Runs locally on the computer.
- Tracks changes in files.
- Creates commits.
- Manages branches and merges.
- Does not require GitHub to work.

GitHub:
- Hosts Git repositories online.
- Stores a remote copy of the project.
- Allows collaboration, pull requests, issues, and portfolio sharing.

Basic flow:

Working Directory
        |
        | git add
        v
Staging Area
        |
        | git commit
        v
Local Git Repository
        |
        | git push
        v
GitHub Remote Repository

---

# 2. Check Git Installation

Check whether Git is installed:

    git --version

Example output:

    git version 2.51.0.windows.1

Find the Git executable:

PowerShell:

    Get-Command git

CMD:

    where git

---

# 3. Configure Git Identity

Configure your name:

    git config --global user.name "Arpit Tiwari"

Configure your email:

    git config --global user.email "arpittiwari1558583@gmail.com"

View all global settings:

    git config --global --list

Check only the configured name:

    git config --global user.name

Check only the configured email:

    git config --global user.email

The `--global` option means that these settings become the default for all Git repositories on this computer.

---

# 4. Initialize the VLSI RTL Repository

Go to the project:

    cd C:\VLSI_RTL

Initialize Git:

    git init

This creates a hidden `.git` directory inside the project.

Conceptually:

    C:\VLSI_RTL
    |
    +-- .git/
    +-- 01_Verilog_Basics/
    +-- 02_Combinational_Circuits/
    +-- 03_Sequential_Circuits/
    +-- ...
    +-- 15_Git/

The `.git` directory stores repository metadata and Git history.

Do not manually modify or delete `.git` unless you intentionally want to remove Git tracking from the repository.

---

# 5. Check Repository Status

Run:

    git status

This tells you:

- Current branch
- Modified files
- New untracked files
- Staged files
- Whether the working tree is clean

Example:

    On branch main

    Changes not staged for commit:
        modified: half_adder.v

    Untracked files:
        full_adder.v

---

# 6. Understanding the Three Main Areas

Git uses three important areas:

    Working Directory
            |
            | git add
            v
       Staging Area
            |
            | git commit
            v
       Local Repository
            |
            | git push
            v
       GitHub Repository

## Working Directory

These are the files you are currently editing.

Example:

    half_adder.v

## Staging Area

Files selected for the next commit.

Command:

    git add half_adder.v

## Local Repository

After committing:

    git commit -m "Add half adder RTL"

the snapshot is permanently recorded in local Git history.

## Remote Repository

After pushing:

    git push

the commits are uploaded to GitHub.

---

# 7. Stage Files

Stage one specific file:

    git add half_adder.v

Stage multiple specific files:

    git add half_adder.v tb_half_adder.v

Stage all changes in the current repository:

    git add .

Check what is staged:

    git status

Important:

`git add .` does not create a commit and does not upload anything to GitHub.

It only prepares changes for the next commit.

---

# 8. Create Commits

Commit staged files:

    git commit -m "Add half adder RTL and testbench"

A commit is a snapshot of the project at a specific point in development.

Good commit messages:

    git commit -m "Add 2-to-1 multiplexer RTL"

    git commit -m "Add half adder self-checking testbench"

    git commit -m "Fix carry output in full adder"

    git commit -m "Implement parameterized 8-bit ALU"

    git commit -m "Add UART transmitter FSM"

Avoid poor commit messages such as:

    git commit -m "update"

    git commit -m "changes"

    git commit -m "fix"

A good commit message should explain what changed.

---

# 9. View Commit History

Detailed history:

    git log

Compact history:

    git log --oneline

Example:

    a3f927c Add full adder RTL and testbench
    91ac254 Add half adder RTL
    4d712be Add multiplexer exercises
    5a14d92 Initial commit

Show branch graph:

    git log --oneline --graph --decorate --all

If Git opens a pager while displaying the log, press:

    q

to exit.

---

# 10. View Changes with git diff

View unstaged changes:

    git diff

View changes staged for the next commit:

    git diff --staged

View changes in one file:

    git diff half_adder.v

Compare two commits:

    git diff <commit1> <commit2>

Example:

    git diff a3f927c 91ac254

---

# 11. Connect Local Repository to GitHub

Your GitHub repository:

    https://github.com/arpittivari/VLSI-RTL

Connect it:

    git remote add origin https://github.com/arpittivari/VLSI-RTL.git

Check connected remotes:

    git remote -v

Expected:

    origin  https://github.com/arpittivari/VLSI-RTL.git (fetch)
    origin  https://github.com/arpittivari/VLSI-RTL.git (push)

If `origin` already exists:

    git remote set-url origin https://github.com/arpittivari/VLSI-RTL.git

View detailed information:

    git remote show origin

---

# 12. Rename the Main Branch

Rename the current branch to `main`:

    git branch -M main

Check current branch:

    git branch

Output:

    * main

The `*` shows the currently active branch.

---

# 13. First Push to GitHub

For the first push:

    git push -u origin main

The `-u` option establishes an upstream tracking relationship:

    Local main
        |
        | tracks
        v
    origin/main

After this, future pushes usually require only:

    git push

---

# 14. Complete First-Time Setup for This Repository

Use this only for initial setup:

    cd C:\VLSI_RTL

    git init

    git config --global user.name "Arpit Tiwari"
    git config --global user.email "arpittiwari1558583@gmail.com"

    git status

    git add .

    git commit -m "Initial commit: VLSI RTL design learning journey"

    git branch -M main

    git remote add origin https://github.com/arpittivari/VLSI-RTL.git

    git push -u origin main

Do not repeat `git init` and `git remote add origin` every day.

---

# 15. Daily Git Workflow

This is the most important workflow to remember.

Suppose you complete the Half Adder:

    git status

    git diff

    git add .

    git status

    git commit -m "Add half adder RTL and self-checking testbench"

    git push

Then you complete the Full Adder:

    git status

    git add .

    git commit -m "Add full adder RTL and testbench"

    git push

The basic daily cycle is:

    EDIT
      |
      v
    git status
      |
      v
    git diff
      |
      v
    git add .
      |
      v
    git commit -m "Meaningful message"
      |
      v
    git push

---

# 16. Pull Latest Changes

Download and integrate changes from GitHub:

    git pull

Explicit form:

    git pull origin main

Conceptually:

    GitHub
       |
       | git pull
       v
    Local Repository + Working Directory

Use this when the remote repository contains commits that are not available locally.

---

# 17. Fetch vs Pull

Fetch:

    git fetch

This downloads remote information but does not automatically merge it into your current branch.

Pull:

    git pull

Conceptually:

    git pull = git fetch + integration

For beginners:

- `git fetch` = Check/download remote changes safely.
- `git pull` = Download and integrate remote changes.

---

# 18. Clone an Existing Repository

To download an existing GitHub repository:

    git clone https://github.com/arpittivari/VLSI-RTL.git

This creates a local copy.

Example:

    cd C:\
    git clone https://github.com/arpittivari/VLSI-RTL.git

Do not normally run `git init` after cloning because `git clone` already creates the Git repository and configures the remote.

---

# 19. Branches

A branch allows development without directly modifying the main branch.

List branches:

    git branch

Create a new branch:

    git branch uart-development

Switch to it:

    git switch uart-development

Create and switch in one command:

    git switch -c uart-development

Older alternative:

    git checkout -b uart-development

Example workflow:

    main
      |
      +---- uart-development
      |
      +---- fifo-development
      |
      +---- cpu-development

For a large RTL project, you might use:

    git switch -c feature/uart-tx

Make changes:

    git add .
    git commit -m "Implement UART transmitter FSM"

Then switch back:

    git switch main

---

# 20. Merge Branches

Suppose `feature/uart-tx` is complete.

Switch to main:

    git switch main

Merge:

    git merge feature/uart-tx

Then push:

    git push

Conceptually:

    main:           A---B---------E
                        \         /
    feature/uart:        C---D---

---

# 21. Delete Branches

Delete a merged local branch:

    git branch -d feature/uart-tx

Force-delete an unmerged local branch:

    git branch -D feature/uart-tx

Use `-D` carefully because unmerged work may become harder to recover.

Delete a remote branch:

    git push origin --delete feature/uart-tx

---

# 22. Undo Unstaged Changes

Suppose you modified:

    half_adder.v

and want to discard the changes:

    git restore half_adder.v

Warning:

This removes uncommitted changes from the working file.

To restore all tracked files:

    git restore .

Use carefully.

---

# 23. Unstage Files

Suppose you ran:

    git add half_adder.v

but don't want it in the next commit.

Use:

    git restore --staged half_adder.v

The changes remain in the working directory but are removed from the staging area.

For all staged files:

    git restore --staged .

---

# 24. Amend the Last Commit

Suppose you forgot a file:

    git add forgotten_file.v

Then:

    git commit --amend --no-edit

Or change the last commit message:

    git commit --amend -m "New improved commit message"

Be careful when amending commits that have already been pushed and shared with others because it rewrites history.

---

# 25. git reset

Reset can move the current branch pointer backward.

Soft reset:

    git reset --soft HEAD~1

Removes the last commit but keeps changes staged.

Mixed reset:

    git reset HEAD~1

Removes the last commit and unstages the changes.

Hard reset:

    git reset --hard HEAD~1

Removes the commit and discards corresponding working-directory changes.

Warning:

    git reset --hard

can permanently discard uncommitted work. Use it carefully.

---

# 26. git revert

To safely undo an existing commit without deleting history:

    git revert <commit_hash>

Example:

    git revert a3f927c

This creates a new commit that reverses the changes introduced by the specified commit.

For shared/public branches, `git revert` is generally safer than rewriting published history.

---

# 27. Stashing Temporary Work

Suppose you're modifying a UART but need to temporarily switch branches.

Save temporary changes:

    git stash

List stashes:

    git stash list

Restore the latest stash:

    git stash pop

Apply without deleting the stash:

    git stash apply

Example:

    git stash
    git switch main
    ...
    git switch feature/uart
    git stash pop

---

# 28. Tags

Tags mark important versions or milestones.

Create a tag:

    git tag v1.0

Create an annotated tag:

    git tag -a v1.0 -m "Completed RTL fundamentals"

Push a tag:

    git push origin v1.0

Push all tags:

    git push origin --tags

Possible milestones:

    v0.1-verilog-basics
    v0.2-combinational
    v0.3-sequential
    v0.4-fsm
    v0.5-uart
    v0.6-fifo
    v1.0-processor-subsystem

---

# 29. .gitignore for VLSI RTL Projects

Generated simulation and build artifacts usually should not be committed.

Recommended `.gitignore`:

    # Icarus Verilog
    *.vvp
    *.vcd
    *.fst

    # ModelSim / Questa
    work/
    work_lib/
    *.wlf
    vsim.wlf
    transcript
    modelsim.ini

    # Yosys generated outputs
    *.json
    *.blif

    # Generic build outputs
    build/
    *.exe
    *.o
    *.obj

    # Logs
    *.log

    # Python
    __pycache__/
    *.pyc

Important:

Do not blindly ignore all synthesis reports, STA reports, constraints, scripts, or netlists. Some of them may be valuable parts of a VLSI portfolio.

For example, you may intentionally commit:

    synth.ys
    constraints.sdc
    timing_summary.rpt
    area_summary.rpt
    README.md

These demonstrate your engineering workflow.

---

# 30. Check Which Files Git Tracks

List tracked files:

    git ls-files

Check whether a file is ignored:

    git check-ignore -v filename.vcd

Example:

    git check-ignore -v wave.vcd

---

# 31. Remove an Already Tracked File but Keep It Locally

Suppose a generated file was accidentally committed:

    git rm --cached wave.vcd

Then add it to `.gitignore`.

For a directory:

    git rm -r --cached build/

Then commit:

    git commit -m "Stop tracking generated build artifacts"

---

# 32. Common Errors

## Error: git is not recognized

Example:

    git : The term 'git' is not recognized

Check:

    git --version

Possible solution:
- Restart the IDE/terminal after installing Git.
- Ensure Git is in PATH.

Typical Windows path:

    C:\Program Files\Git\cmd

---

## Error: remote origin already exists

Use:

    git remote -v

Then update it:

    git remote set-url origin https://github.com/arpittivari/VLSI-RTL.git

---

## Error: no configured push destination

Connect a remote:

    git remote add origin https://github.com/arpittivari/VLSI-RTL.git

Then:

    git push -u origin main

---

## Error: rejected non-fast-forward

Do not immediately force push.

First inspect:

    git status
    git log --oneline --graph --decorate --all

Then usually:

    git pull --rebase origin main

Resolve conflicts if necessary, then:

    git push

Do not use `git push --force` unless you understand exactly which remote history will be overwritten.

---

# 33. Merge Conflicts

A conflict can occur when Git cannot automatically combine changes.

Example:

    CONFLICT (content): Merge conflict in alu.v

The file may contain:

    <<<<<<< HEAD
    assign result = a + b;
    =======
    assign result = a - b;
    >>>>>>> feature-branch

You must decide the correct code, remove the conflict markers, then:

    git add alu.v
    git commit

For a rebase conflict, after resolving:

    git add alu.v
    git rebase --continue

---

# 34. Useful Inspection Commands

Current status:

    git status

Compact status:

    git status --short

History:

    git log --oneline

Graph:

    git log --oneline --graph --decorate --all

Current branch:

    git branch --show-current

Remote repositories:

    git remote -v

Difference before staging:

    git diff

Difference after staging:

    git diff --staged

Show a commit:

    git show <commit_hash>

List tracked files:

    git ls-files

---

# 35. Recommended VLSI RTL Git Workflow

For each module:

1. Understand the specification.
2. Write RTL.
3. Write the testbench.
4. Simulate using Icarus or ModelSim.
5. Debug using GTKWave or ModelSim waveforms.
6. Verify corner cases.
7. Check generated artifacts are ignored where appropriate.
8. Inspect changes.
9. Commit with a meaningful message.
10. Push to GitHub.

Commands:

    git status
    git diff
    git add .
    git diff --staged
    git commit -m "Add half adder RTL and verification testbench"
    git push

---

# 36. Recommended Commit History for This Journey

Example:

    Initial commit: Set up VLSI RTL design repository
    Add Verilog syntax fundamentals
    Add logic gates RTL and testbench
    Implement 2-to-1 multiplexer
    Implement 4-to-1 multiplexer
    Add decoder and comparator designs
    Add half adder RTL and verification
    Add full adder RTL and testbench
    Implement parameterized ripple carry adder
    Implement parameterized ALU
    Add D flip-flop and register designs
    Add synchronous counter
    Add shift register
    Implement sequence detector FSM
    Add SystemVerilog self-checking testbenches
    Implement UART transmitter
    Implement UART receiver
    Implement synchronous FIFO
    Implement asynchronous FIFO with CDC synchronization
    Add register file
    Implement single-cycle processor
    Implement pipelined processor subsystem

---

# 37. Quick Cheat Sheet

Setup:

    git config --global user.name "Arpit Tiwari"
    git config --global user.email "arpittiwari1558583@gmail.com"

Initialize:

    git init

Status:

    git status

Stage:

    git add .

Commit:

    git commit -m "Description"

Push:

    git push

Pull:

    git pull

History:

    git log --oneline

Changes:

    git diff

Branches:

    git branch

New branch:

    git switch -c feature-name

Switch branch:

    git switch branch-name

Merge:

    git merge branch-name

Unstage:

    git restore --staged filename

Discard uncommitted changes:

    git restore filename

Temporary save:

    git stash

Restore stash:

    git stash pop

Remote:

    git remote -v

---

# 38. Most Important Commands to Memorize First

You do not need to memorize every Git command immediately.

Start with these:

    git status
    git diff
    git add .
    git commit -m "Meaningful message"
    git push
    git pull
    git log --oneline
    git branch
    git switch
    git restore

Your daily workflow will usually be:

    git status
    git diff
    git add .
    git commit -m "Describe what you completed"
    git push

---

# Final Mental Model

Remember this:

    Your edited RTL files
            |
            | git add
            v
       Staging Area
            |
            | git commit
            v
       Local Git History
            |
            | git push
            v
          GitHub

And in the opposite direction:

          GitHub
            |
            | git pull
            v
       Local Computer

Git tracks the evolution of your engineering work. GitHub stores and presents that work remotely.
