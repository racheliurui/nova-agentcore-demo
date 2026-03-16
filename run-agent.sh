#!/bin/bash
# Usage: ./run-agent.sh <agent-name>
# Override restart delay: RESTART_DELAY=60 ./run-agent.sh project-developer
# Runs inside a tmux session so it survives SSH disconnects.
# Reattach: tmux attach -t <agent-name>
# Kill: tmux kill-session -t <agent-name>

AGENT=$1
RESTART_DELAY=${RESTART_DELAY:-300}

if [ -z "$AGENT" ]; then
  echo "Usage: ./run-agent.sh <agent-name>"
  exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"

# If already inside tmux, just run the loop
if [ -n "$TMUX" ]; then
  cd "$DIR"
  export TERM=dumb
  while true; do
    echo "[$AGENT] Starting in $DIR at $(date)..."
    echo "start your work and keep looping until blocked" | kiro-cli chat --agent $AGENT --trust-all-tools --no-interactive 2>&1 | cat
    echo "[$AGENT] Exited at $(date). Restarting in ${RESTART_DELAY}s..."
    sleep $RESTART_DELAY
  done
  exit 0
fi

# Otherwise, launch inside a new tmux session
tmux has-session -t "$AGENT" 2>/dev/null && tmux kill-session -t "$AGENT"
tmux new-session -d -s "$AGENT" -c "$DIR" "RESTART_DELAY=$RESTART_DELAY $DIR/run-agent.sh $AGENT"
echo "Agent '$AGENT' started in tmux session."
echo "  Attach:  tmux attach -t $AGENT"
echo "  Detach:  Ctrl+B then D"
echo "  Kill:    tmux kill-session -t $AGENT"
