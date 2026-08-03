
#!/usr/bin/env bash
# Configuration
PROJECTS_DIR="$HOME/projects"

# Function to select a project
select_project() {
if [[ $# -eq 1 ]]; then
    echo "$1"
else
    find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d,l | fzf
fi
}

# Function to sanitize session name
sanitize_name() {
    basename "$1" | tr . _
}

# Function to check if tmux is running
is_tmux_running() {
    pgrep tmux > /dev/null
}

# Function to create or attach to session
manage_session() {
    local selected="$1"
    local session_name
    session_name=$(sanitize_name "$selected")

    # Create new session if it doesn't exist
    if ! tmux has-session -t="$session_name" 2> /dev/null; then
        tmux new-session -ds "$session_name" -c "$selected"
    fi

    # Attach or switch to session
    if [[ -z ${TMUX:-} ]]; then
        tmux attach -t "$session_name"
    else
        tmux switch-client -t "$session_name"
    fi
    }

    # Main execution
    main() {
    local selected
    selected=$(select_project "$@") || true

    # Exit if no selection
    if [[ -z $selected ]]; then
        return 0
    fi

    # Start new tmux session if none exists
    if [[ -z ${TMUX:-} ]] && ! is_tmux_running; then
        tmux new-session -s "$(sanitize_name "$selected")" -c "$selected"
        return 0
    fi

    # Manage existing session
    manage_session "$selected"
}

# Run main function with all arguments
main "$@"
