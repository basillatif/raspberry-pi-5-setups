# Running an LLM with Ollama

This sets up the Pi 5 as a local LLM host using [Ollama](https://ollama.com).
With 8 GB of RAM, the Pi runs small models (1B-3B parameters) at usable
speeds on CPU. Larger 7B models will run but are noticeably slower.

## 1. Install Ollama

```bash
ssh -t bobbypi "curl -fsSL https://ollama.com/install.sh | sh"
```

This installs Ollama as a systemd service listening on `127.0.0.1:11434`.
Check it's running:

```bash
ssh bobbypi "ollama --version && systemctl is-active ollama"
```

## 2. Pull a model

`llama3.2:3b` is a good starting point for an 8 GB Pi 5 (~2 GB download):

```bash
ssh bobbypi "ollama pull llama3.2:3b"
```

Other options to try:

- `phi3` - small and fast, good for quick responses
- `qwen2.5:3b` - strong for its size
- `llama3.2:1b` - fastest, lowest quality, good for tight RAM

## 3. Run it

Interactive chat:

```bash
ssh -t bobbypi "ollama run llama3.2:3b"
```

Via the local API:

```bash
curl -s http://bobbypi.local:11434/api/generate -d '{
  "model": "llama3.2:3b",
  "prompt": "What is 2+2?",
  "stream": false
}'
```

## 4. Access from other devices on your network

By default Ollama binds to `127.0.0.1`. To reach it from your Mac or other
devices on your home network, create a systemd override:

```bash
ssh -t bobbypi "sudo mkdir -p /etc/systemd/system/ollama.service.d && \
printf '[Service]\nEnvironment=\"OLLAMA_HOST=0.0.0.0\"\n' | sudo tee /etc/systemd/system/ollama.service.d/override.conf && \
sudo systemctl daemon-reload && sudo systemctl restart ollama"
```

Then from another machine on the same network:

```bash
curl http://bobbypi.local:11434/api/generate -d '{
  "model": "llama3.2:3b",
  "prompt": "What is 2+2?",
  "stream": false
}'
```

Only do this on a trusted home network — the API has no authentication.

## Notes

- Ollama runs CPU-only on the Pi 5 (no GPU). A 3B model responds in a few
  seconds for short prompts.
- Models are stored under `/usr/share/ollama/.ollama/models`. Check disk usage
  with `df -h` if you pull multiple models.
