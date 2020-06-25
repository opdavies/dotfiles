# Returns the name of the most recent tmux session, sorted by time the session
# was last attached.
_most_recent_tmux_session(){
  tmux list-sessions -F "#{session_last_attached} #{session_name}" | \
    sort -r | \
    cut -d' ' -f2 | \
    head -1
}

connect_to_most_recent_tmux_session() {
  if _not_inside_tmux && _any_tmux_sessions; then
    tmux attach -t "$(_most_recent_tmux_session)"
  fi
}

_any_tmux_sessions() {
  [[ -n "$(tmux ls 2>/dev/null)" ]]
}

# Returns the name of the most recent tmux session, sorted by time the session
# was last attached.
_most_recent_tmux_session() {
  tmux list-sessions -F "#{session_last_attached} #{session_name}" | \
    sort -r | \
    cut -d' ' -f2 | \
    head -1
}

_not_inside_tmux() {
  [[ -z "$TMUX" ]]
}

_not_inside_phpstorm() {
  if is_macos; then
    # VS Code returns "vscode".
    # iTerm returns "iTerm.app".
    # PhpStorm returns nothing.
    [[ "$TERM_PROGRAM" != "" ]]
  elif is_linux; then
    [[ "$TERMINAL_EMULATOR" != "JetBrains"* ]]
  fi
}

ensure_tmux_is_running() {
  if _not_inside_tmux && _not_inside_phpstorm; then
    connect_to_most_recent_tmux_session
  fi
}

ensure_tmux_is_running
