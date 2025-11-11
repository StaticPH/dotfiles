# Additional git commands
* git autosquash: More accurately, a squash helper script, for people that make a mess because they can't figure out git command syntax
* git cherry-file: Cherry pick paths selectively from a commit
* git logfuzz: Use `fzf` to search through git logs, with `delta` for previewing
* git prune-preview: Use `fzf` and `delta` to preview refs that would be removed by `git prune`
* git orphan-tree: Convenience script for creating git worktrees with disconnected histories. Made before there was a simple flag to do that.
* git glossary:	Try to open a man page containing a glossary of terms used by git
* git rmBranch:	Delete a branch
* git unstash:	**NYI** Unstash a branch. (There is an extra # on line 1 to prevent the file from showing up in completion)

Commands added this way will show up in tab completion for multi-segment git commands, with '-' denoting a segment.<br>
The first segment of each command **must** be 'git'.<br>
	i.e. `git-unstash` will add `unstash` to the tab-completion list for `git `<br>

_caveat: While commands added this way **DO** show up in tab completion for multi-segment git commands, they **ALSO** show up in the tab-completion
results for `gi` and `git-`_<br>

###### Some helpful snippets for writing commands can be found at `"$(git --exec-path)/git-sh-setup"`

## ?TODO? :
* git-merge-base
* git-rev-list
* git-show-ref
* git-var
* git-check-ignore
* git-credential
* check if local repo has a remote repo
