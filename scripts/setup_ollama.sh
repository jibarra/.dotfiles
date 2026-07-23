brew services start ollama

ollama pull qwen3.6:27b          # daily driver: chat + reasoning + code
ollama pull qwen3-coder:30b      # coding (for OpenCode)
ollama pull gemma4:26b           # multimodal + multilingual

# Create qwen3-coder:30b extended context variant
ollama create qwen3-coder:30b-64k -f <(cat <<'EOF'
FROM qwen3-coder:30b
PARAMETER num_ctx 65536
EOF
)

