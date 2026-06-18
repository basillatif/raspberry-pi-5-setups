#!/bin/bash
# Send a call transcript to the Pi's Ollama instance and extract action items.
#
# Usage: ./analyze_transcript.sh /path/to/transcript.txt

set -euo pipefail

TRANSCRIPT_FILE="${1:?Usage: $0 <transcript-file>}"
OLLAMA_HOST="${OLLAMA_HOST:-http://bobbypi.local:11434}"
MODEL="${MODEL:-llama3.2:3b}"

PROMPT="Below is a call transcript. Extract a clear list of action items, \
follow-ups, and commitments made by each person. If none, say so. \
Respond with a concise bulleted list grouped by who owns each item.

TRANSCRIPT:
$(cat "$TRANSCRIPT_FILE")"

jq -n --arg model "$MODEL" --arg prompt "$PROMPT" --argjson num_ctx 8192 \
  '{model: $model, prompt: $prompt, stream: false, options: {num_ctx: $num_ctx}}' \
  | curl -s "$OLLAMA_HOST/api/generate" -d @- \
  | jq -r '.response'
