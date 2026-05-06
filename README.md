# 🔌 Sota VLESS Script

One-click updater for Sota Connect VPN servers. Extracts fresh VLESS configurations for all locations directly from the official API.


---

## 🚀 One-line Install & Run

### macOS / Linux

```bash
curl -L https://raw.githubusercontent.com/AlexRuBot/sota_script/main/scripts/install.sh | bash
```

### Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/AlexRuBot/sota_script/main/scripts/install.ps1 | iex
```

That's it! The installer will:
1. Detect your OS and architecture
2. Download the correct binary from GitHub Releases
3. Install to `~/.local/bin` (macOS/Linux) or `%LOCALAPPDATA%\Programs` (Windows)
4. **Launch immediately** and ask for your Access Key

---

## 🔑 How to get your Access Key

1. Open the Sota Telegram bot (usually `@sotavpnbot`)
2. Send `/start` or request a key
3. Copy the Access Key (looks like `f9b3a1e4-3716-4f20-981a-0534d859be44`)
4. Paste it when the updater asks

---

## 📦 Manual Download

If you prefer to download manually, grab the binary for your platform from [Releases](https://github.com/AlexRuBot/sota_script/releases):

| Platform | Architecture | File |
|---|---|---|
| macOS (Apple Silicon) | ARM64 | `sota_vless_updater_darwin_arm64` |
| macOS (Intel) | AMD64 | `sota_vless_updater_darwin_amd64` |
| Windows 10/11 | AMD64 | `sota_vless_updater_windows_amd64.exe` |
| Linux | AMD64 | `sota_vless_updater_linux_amd64` |

```bash
# Example: macOS Apple Silicon
chmod +x sota_vless_updater_darwin_arm64
./sota_vless_updater_darwin_arm64
```

---

## 🔧 Environment Variable

Skip the interactive prompt by setting your key upfront:

```bash
# macOS / Linux
export SOTA_ACCESS_KEY="your_key_here"
./sota_vless_updater

# Windows PowerShell
$env:SOTA_ACCESS_KEY = "your_key_here"
.\sota_vless_updater_windows_amd64.exe

# Windows CMD
set SOTA_ACCESS_KEY=your_key_here
sota_vless_updater_windows_amd64.exe
```

---

## 📁 Output

The updater creates two files on your **Desktop** (or current directory):

- `sota_vless_YYYY-MM-DD_HH-MM-SS.md` — Markdown table with all server details
- `sota_vless_YYYY-MM-DD_HH-MM-SS.txt` — Plain list of VLESS URLs for import

---

## ⚠️ Troubleshooting

| Issue | Solution |
|---|---|
| `permission denied` | Run `chmod +x ./sota_vless_updater_*` |
| macOS "developer cannot be verified" | Go to **System Settings → Privacy & Security** → Click **Allow Anyway** |
| `HTTP 401` | Your Access Key is invalid or expired. Get a new one from the bot. |
| No locations returned | Check your internet connection. The API is protected by QRATOR but usually allows requests. |

---

## 📄 License

MIT License — feel free to use, modify, and distribute.
