
# Install hook
Set hooks path to `.githooks`:

```bash
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit
chmod +x scripts/install_gitleaks.sh

## Demo (Telegram token)
```bash
git config hooks.gitleaks.enable true
echo 'TELEGRAM_BOT_TOKEN=1234567890:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' > test.txt
git add test.txt
git commit -m "test: telegram token"
# [gitleaks] Secrets detected — commit REJECTED.