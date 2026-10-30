#!/data/data/com.termux/files/usr/bin/sh
# LocAI installer for Termux (no root needed)
set -e

REPO_RAW="https://raw.githubusercontent.com/TEDDY-47/LocAI/main"
LOCAI_HOME="$HOME/.locai"
MODEL_URL="https://huggingface.co/unsloth/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q4_K_M.gguf"
MODEL_FILE="$LOCAI_HOME/models/model.gguf"

echo "== LocAI installer =="

# Check the device
RAM_MB=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo)
CORES=$(nproc 2>/dev/null || echo 4)
FREE_MB=$(df -Pk "$HOME" 2>/dev/null | awk 'NR==2 {print int($4/1024)}')
[ -z "$FREE_MB" ] && FREE_MB=99999
echo "RAM: ${RAM_MB} MB | CPU cores: ${CORES} | Free storage: ${FREE_MB} MB"

if [ "$FREE_MB" -lt 1000 ]; then
  echo "Not enough free storage (need about 1 GB). Free some space and retry."
  exit 1
fi
if [ "$RAM_MB" -lt 2000 ]; then
  echo "Warning: low RAM, LocAI may be slow or get killed by Android."
fi

# Light defaults: 4 threads at most
if [ "$CORES" -ge 4 ]; then THREADS=4; else THREADS="$CORES"; fi

# Install packages (llama.cpp is a ready-made Termux package, no compiling)
pkg update -y
pkg install -y llama-cpp wget curl

# Install the locai command and config
mkdir -p "$LOCAI_HOME/models"
curl -fsSL "$REPO_RAW/locai" -o "$PREFIX/bin/locai"
chmod +x "$PREFIX/bin/locai"
if [ ! -f "$LOCAI_HOME/config.conf" ]; then
  curl -fsSL "$REPO_RAW/config.conf" -o "$LOCAI_HOME/config.conf"
  sed -i "s/^THREADS=[0-9]*/THREADS=$THREADS/" "$LOCAI_HOME/config.conf"
fi

# Download the default model (Qwen3 0.6B, about 400 MB)
if [ -f "$MODEL_FILE" ]; then
  echo "Model already installed."
else
  wget -c "$MODEL_URL" -O "$MODEL_FILE.part"
  mv "$MODEL_FILE.part" "$MODEL_FILE"
fi

echo ""
echo "Done! Try:"
echo "  locai start"
echo "  locai chat"
