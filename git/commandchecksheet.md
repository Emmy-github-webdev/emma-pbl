# Git
Git is a free open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

#### Sematic versioning
```
Format: 1.2.0. 
Where 
1 = Major(Major changes or backward incompatible) 
2 = minor(New feature, or an improvement) 
0 = patch(Bug fixes)
```

```
### Tag a commit
git tag TagName commit
git show tag


### Annotated Tags
git tag -a TagName -m "message" [commit]
git tag -a v2.1.6 -m "Realease for something"

### Push Tags
git push origin tag TagName
git push --tags
```


#### Git Basics

| Command                        | Example Use Case                             | Description                                                                       |                                                       |
| ------------------------------ | -------------------------------------------- | --------------------------------------------------------------------------------- | ----------------------------------------------------- |
| `git init <directory>`         | `git init my-project`                        | Create an empty Git repo in a directory (or init current directory with no args). |                                                       |
| `git clone <repo>`             | `git clone https://github.com/user/repo.git` | Clone a remote or local repo onto your machine.                                   |                                                       |
| `git add <directory            | file>`                                       | `git add src/`                                                                    | Stage changes in directory (or file) for next commit. |
| `git commit -m "<message>"`    | `git commit -m "Fix login bug"`              | Commit staged changes with a message (no editor).                                 |                                                       |
| `git status`                   | `git status`                                 | List staged, unstaged, and untracked files.                                       |                                                       |
| `git log`                      | `git log`                                    | Show full commit history.                                                         |                                                       |
| `git log --oneline`            | `git log --oneline`                          | Show compact commit history.                                                      |                                                       |
| `git log --stat`               | `git log --stat`                             | Show files changed and lines added/removed in each commit.                        |                                                       |
| `git log -p`                   | `git log -p`                                 | Show full diff of each commit.                                                    |                                                       |
| `git log --author="<pattern>"` | `git log --author="Alice"`                   | Search commits by author name.                                                    |                                                       |
| `git log --grep="<pattern>"`   | `git log --grep="bug"`                       | Search commits by commit message.                                                 |                                                       |
| `git log <since>..<until>`     | `git log HEAD~5..HEAD`                       | Show commits between two refs.                                                    |                                                       |
| `git log -- <file>`            | `git log -- app.js`                          | Show commit history for a specific file.                                          |                                                       |
| `git log --graph --decorate`   | `git log --graph --decorate`                 | Show visual graph of commits with branch/tag names.                               |                                                       |
| `git log -<limit>`             | `git log -5`                                 | Limit output to number of commits.                                                |                                                       |

#### Working With Changes

| Command             | Example Use Case    | Description                                                |
| ------------------- | ------------------- | ---------------------------------------------------------- |
| `git diff`          | `git diff`          | Show unstaged changes between index and working directory. |
| `git diff HEAD`     | `git diff HEAD`     | Show difference between working directory and last commit. |
| `git diff --cached` | `git diff --cached` | Show differences between staged changes and last commit.   |

#### Undoing Changes

| Command               | Example Use Case    | Description                                                      |
| --------------------- | ------------------- | ---------------------------------------------------------------- |
| `git reset <file>`    | `git reset app.js`  | Unstage a file without modifying working directory.              |
| `git clean -n`        | `git clean -n`      | Show which untracked files would be removed.                     |
| `git clean -f`        | `git clean -f`      | Remove untracked files.                                          |
| `git revert <commit>` | `git revert abc123` | Create a commit that undoes the changes of the specified commit. |

#### Git Reset (History)

| Command                     | Example Use Case          | Description                                                          |
| --------------------------- | ------------------------- | -------------------------------------------------------------------- |
| `git reset`                 | `git reset`               | Reset staging area to match last commit but keep working directory.  |
| `git reset --hard`          | `git reset --hard`        | Reset staging area and working directory to last commit.             |
| `git reset <commit>`        | `git reset abc123`        | Move branch tip and reset staging area, keep working directory.      |
| `git reset --hard <commit>` | `git reset --hard abc123` | Reset branch tip, staging area, and working directory to `<commit>`. |

#### Branching

| Command                    | Example Use Case                | Description                                          |
| -------------------------- | ------------------------------- | ---------------------------------------------------- |
| `git branch`               | `git branch`                    | List branches; add `<branch>` to create new one.     |
| `git checkout -b <branch>` | `git checkout -b feature-login` | Create and switch to a new branch.                   |
| `git merge <branch>`       | `git merge feature-login`       | Merge branch into current branch.                    |
| `git rebase <base>`        | `git rebase main`               | Rebase current branch onto `<base>`.                 |
| `git reflog`               | `git reflog`                    | Show log of all changes to HEAD.                     |
| `git rebase -i <base>`     | `git rebase -i HEAD~5`          | Interactively rebase to edit/reorder/squash commits. |

#### Remote Repositories

| Command                       | Example Use Case                               | Description                                        |
| ----------------------------- | ---------------------------------------------- | -------------------------------------------------- |
| `git remote add <name> <url>` | `git remote add origin https://github.com/...` | Add remote connection.                             |
| `git fetch <remote> <branch>` | `git fetch origin main`                        | Fetch a specific branch; omit branch to fetch all. |
| `git pull <remote>`           | `git pull origin`                              | Fetch and merge remote branch into local branch.   |
| `git pull --rebase <remote>`  | `git pull --rebase origin`                     | Fetch and rebase instead of merge.                 |
| `git push <remote> <branch>`  | `git push origin main`                         | Push branch and commits to remote.                 |
| `git push <remote> --force`   | `git push origin --force`                      | Force-push (dangerous).                            |
| `git push <remote> --all`     | `git push origin --all`                        | Push all branches.                                 |
| `git push <remote> --tags`    | `git push origin --tags`                       | Push all local tags.                               |

#### Git Config

| Command                                    | Example Use Case                                 | Description                               |
| ------------------------------------------ | ------------------------------------------------ | ----------------------------------------- |
| `git config user.name <name>`              | `git config user.name "Alice"`                   | Set commit author name for current repo.  |
| `git config user.email <email>`            | `git config user.email "a@example.com"`          | Set commit author email for current repo. |
| `git config --global user.name <name>`     | `git config --global user.name "Alice"`          | Set global Git author name.               |
| `git config --global user.email <email>`   | `git config --global user.email "a@example.com"` | Set global author email.                  |
| `git config --system core.editor <editor>` | `git config --system core.editor vim`            | Set system-wide default text editor.      |
| `git config --global --edit`               | `git config --global --edit`                     | Open global config in editor.             |
| `git config --global alias.<alias> <cmd>`  | `git config --global alias.st status`            | Create Git command alias.                 |
