# Adaptive prompt that will be shortened if there is room. Set the
# following to your preferred threshold.

PROMPT_LONG=50
PROMPT_MAX=95

__git_status_ps1() {
  # set shortcuts for all the colors
  if test -n "${ZSH_VERSION}"; then
    local sc='%F{red}'
    local uc='%F{green}'
  else
    local sc='\[\e[92m\]'
    local uc='\[\e[93m\]'
  fi

  local exit=$?

  local repo_info rev_parse_exit_code
  repo_info="$(git rev-parse --git-dir --is-inside-git-dir \
    --is-bare-repository --is-inside-work-tree \
    --short HEAD 2>/dev/null)"
  rev_parse_exit_code="$?"

  if [ -z "$repo_info" ]; then
    return $exit
  fi

  if [ "$rev_parse_exit_code" = "0" ]; then
    repo_info="${repo_info%$'\n'*}"
  fi

  local inside_worktree="${repo_info##*$'\n'}"

  if [ "true" = "$inside_worktree" ]; then
    local branch=$(git branch --show-current 2>/dev/null)
    test "${dir}" = "${branch}" && branch='.'
    test "${branch}" = master -o "${branch}" = main && b=$r

    local unstaged=""
    local staged=""
    git diff --no-ext-diff --quiet || unstaged="$(git diff --numstat | wc -l)±"
    git diff --no-ext-diff --cached --quiet || staged="$(git diff --cached --numstat | wc -l)•"

    test -n "$unstaged" && colored_git="$colored_git $uc$unstaged" && git="$git $unstaged"
    test -n "$staged" && colored_git="$colored_git $sc$staged" && git="$git $staged"
    colored_git="$g($b$branch$colored_git$g)"
    git="($branch$git)"
  fi
}

__ps1() {

  local P='$' # changes to hashtag when root

  # set shortcuts for all the colors
  if test -n "${ZSH_VERSION}"; then
    local r='%F{red}'
    local g='%F{black}'
    local h='%F{blue}'
    local u='%F{yellow}'
    local p='%F{yellow}'
    local w='%F{magenta}'
    local b='%F{cyan}'
    local x='%f'
  else
    local r='\[\e[31m\]'
    local g='\[\e[32m\]'
    local h='\[\e[34m\]'
    local u='\[\e[33m\]'
    local p='\[\e[33m\]'
    local w='\[\e[35m\]'
    local b='\[\e[36m\]'
    local x='\[\e[0m\]'
  fi

  # watch out, you're root
  if test "${EUID}" == 0; then
    P='#'
    if test -n "${ZSH_VERSION}"; then
      u='$F{red}'
    else
      u=$r
    fi
    p=$u
  fi

  local dir="$(basename $PWD)"
  if test "${PWD}" = "$HOME"; then
    dir="~"
  elif test "${dir}" = _; then
    dir=${PWD#*${PWD%/*/_}}
    echo "${dir}"
    dir=${dir#/}
  elif test "${dir}" = work; then
    dir=${PWD#*${PWD%/*/work}}
    dir=${dir#/}
  fi
  local git=""
  local colored_git=""
  __git_status_ps1

  local countme="$USER@$(hostname):$dir($git)\$ "
  git=$colored_git

  # let's see how long this thing really is
  if test -n "${ZSH_VERSION}"; then
    local short="$u%n$g@$h%m$g:$w$dir$git$p$P$x "
    local long="$g╔ $u%n$g@%m\h$g:$w$dir$git\n$g╚ $p$P$x "
    local double="$g╔ $u%n$g@%m\h$g:$w$dir\n$g║ $git\n$g╚ $p$P$x "
  else
    local short="$u\u$g@$h\h$g:$w$dir$git$p$P$x "
    local long="$g╔ $u\u$g@$h\h$g:$w$dir$git\n$g╚ $p$P$x "
    local double="$g╔ $u\u$g@$h\h$g:$w$dir\n$g║ $git\n$g╚ $p$P$x "
  fi

  if test ${#countme} -gt "${PROMPT_MAX}"; then
    PS1="${double}"
  elif test ${#countme} -gt "${PROMPT_LONG}"; then
    PS1="${long}"
  else
    PS1="${short}"
  fi
}

PROMPT_COMMAND="${PROMPT_COMMAND:+PROMPT_COMMAND;}__ps1;"
