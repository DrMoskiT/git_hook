
# Gitleaks pre-commit hook

Репозиторій містить `pre-commit` hook для Git, який:
- автоматично запускає перевірку на секрети перед комітом;
- автоматично встановлює `gitleaks` залежно від ОС (Linux/macOS/Windows Git Bash);
- блокує коміт, якщо знайдені секрети;
- має перемикач enable/disable через `git config`.

---

## Вимоги
- `git`
- `bash`
- `curl`, `tar` (зазвичай вже є в Linux/macOS; на Windows — Git Bash)

---

## Встановлення

### 1) Увімкнути використання локальних hook-ів репозиторію
У корені репозиторію виконай:


git config core.hooksPath .githooks

### 2) Дати права на виконання

chmod +x .githooks/pre-commit
chmod +x scripts/install_gitleaks.sh

---

## Налаштування (enable/disable)-
### Увімкнути (за замовчуванням увімкнено)
git config hooks.gitleaks.enable true

### Вимкнути
git config hooks.gitleaks.enable false

---

## Demo (Telegram token)
git config hooks.gitleaks.enable true
echo 'TELEGRAM_BOT_TOKEN=1234567890:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' > test.txt
git add test.txt
git commit -m "test: telegram token"
# [gitleaks] Secrets detected — commit REJECTED.
