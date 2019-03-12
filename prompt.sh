find_git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  exec 3>&2
  exec 2> /dev/null
  if branch=$(git status -sb | head -n 1 | sed 's/^## //g' | sed 's/\.\.\./ -> /g' | sed 's/origin/o/g' | sed 's/upstream/u/'); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    if [[ "$branch" != "" ]]; then
        remotes=$(git remote | awk '{print substr($1,1,1)}' | tr '\n' ',' | sed 's/,$//g')
        git_branch="($branch) [$remotes]"
    else
        git_branch=""
    fi
  else
    git_branch=""
  fi
  exec 2>&3
}

find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    git_dirty='*'
  else
    git_dirty=''
  fi
}

PROMPT_COMMAND="find_git_branch; find_git_dirty; $PROMPT_COMMAND"

# Default Git enabled prompt with dirty state
# export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Another variant:
# export PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "

# Default Git enabled root prompt (for use with "sudo -s")
# export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
