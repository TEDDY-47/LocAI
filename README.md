# LocAI

**A light local AI chatbot for your phone. No root, no account, no internet after setup.**

LocAI runs a small language model (llama.cpp) inside Termux and gives you a chat page in your browser plus an OpenAI-compatible API on `localhost`. Everything stays on your device.

## Install

In Termux (install it from F-Droid or GitHub, not the Play Store):

```
curl -fsSL https://raw.githubusercontent.com/TEDDY-47/LocAI/main/install.sh | sh
```

It checks your RAM and storage, installs llama.cpp, and downloads a ~400 MB model. Needs about 1 GB free.

## Use

```
locai start      # start the server
locai chat       # open the chat page in your browser
locai stop       # stop it and free the RAM
locai status
locai model <url>   # switch to another GGUF model
locai log
```

API (OpenAI-compatible): `http://127.0.0.1:8080/v1/chat/completions`

## Why it's light

- Small download: the app itself is a few MB, the model is your choice
- Starts only when you ask, and unloads the model after 10 idle minutes (if your llama.cpp build supports it)
- Low defaults: 4 threads, 2048 context, 1 parallel chat, CPU only
- Local only: listens on `127.0.0.1`, so nothing else can reach it

## Benchmarks

Redmi K20 (Snapdragon 730), Qwen3 0.6B Q4_K_M, llama.cpp from the Termux package:

| Threads | Prompt (t/s) | Generation (t/s) |
|---|---|---|
| 2 | 22.8 | 14.7 |
| 4 | 24.8 | **16.4** |
| 6 | 32.4 | 13.5 (unstable) |

RAM use is about 620 MB. More threads is not faster for generation, so 4 is the default. Add your device to the table with a PR.

## Limits

- It's a 0.6B model: fine for chat and simple questions, weak at facts and reasoning
- No web access, so it can't look anything up
- Speed depends heavily on your phone

## Config

Edit `~/.locai/config.conf` (threads, context size, port, idle timeout).

## Uninstall

```
locai stop
rm $PREFIX/bin/locai
rm -rf ~/.locai
```

## Roadmap

- Magisk module for start-on-boot (rooted phones)
- Auto model suggestions by RAM
- Linux and desktop wrappers

## Credits

[llama.cpp](https://github.com/ggml-org/llama.cpp) and the Qwen3 model team (Apache 2.0). MIT licensed.
