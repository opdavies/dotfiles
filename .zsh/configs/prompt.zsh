source /usr/lib/git-core/git-sh-prompt

git_is_repo() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
    return 1
  fi

  return 0
}

git_current_branch() {
  echo $(git rev-parse --abbrev-ref HEAD)
}

git_repo_is_dirty() {
  if [[ -z $(git status --short) ]]; then
    return 1;
  fi

  return 0;
}

git_prompt_info() {
  ! git_is_repo || return

  current_branch=$(git_current_branch 2> /dev/null)
  current_commit=$(git rev-parse --short HEAD 2> /dev/null)
  suffix=''

  if [[ ! -z ${current_commit} ]]; then
    suffix="${suffix} [%{$fg_bold[yellow]%}${current_commit}%{$reset_color%}]"
  fi

  if git_repo_is_dirty; then
    suffix="${suffix} %{$fg_bold[red]%}*%{$reset_color%}"
  fi

  if [[ -n git_current_branch ]]; then
    echo " %{$fg_bold[green]%}$(__git_ps1 %s)%{$reset_color%}${suffix}"
  fi
}

setopt promptsubst

export PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%~%{$reset_color%}$(git_prompt_info) \$ '
