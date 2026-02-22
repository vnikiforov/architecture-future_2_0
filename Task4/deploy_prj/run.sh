#!/usr/bin/env bash
# run.sh — запуск Terraform в mock-режиме

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# === Справка ===
show_help() {
  cat << EOF
🚀 Terraform Mock Runner для проекта Future2.0

Использование:
  $0 <command> [options]

Команды:
  init      — Инициализация Terraform (скачивает провайдеры)
  plan      — Генерация плана изменений
  apply     — Применение конфигурации
  destroy   — Уничтожение ресурсов и очистка mock-файлов
  validate  — Валидация синтаксиса конфигурации
  status    — Показать состояние mock-ресурсов
  help      — Эта справка

Примеры:
  $0 init                    # Первая инициализация
  $0 plan                    # Посмотреть план
  $0 apply                   # Применить (создать mock-файлы)
  $0 destroy                 # Очистить всё

Переменные окружения:
  TF_VAR_use_azure_provider  # true/false (по умолчанию: false)
  TF_VAR_environment         # dev/stage/prod (по умолчанию: dev)
  TF_VAR_admin_password      # Пароль для тестовых VM

  # Для переключения на реальный Azure (если use_azure_provider=true):
  ARM_SKIP_PROVIDER_REGISTRATION=true
  ARM_SKIP_CREDENTIALS_VALIDATION=true
  ARM_CLIENT_ID="..."
  ARM_TENANT_ID="..."
  ARM_SUBSCRIPTION_ID="..."

EOF
}

# === Проверка аргумента ===
if [[ $# -eq 0 ]]; then
  show_help
  exit 0
fi

# === Настройки по умолчанию ===
export TF_VAR_use_azure_provider="${TF_VAR_use_azure_provider:-false}"
export TF_VAR_environment="${TF_VAR_environment:-dev}"
export TF_VAR_admin_password="${TF_VAR_admin_password:-P@ssw0rd123!}"

# === Mock-переменные для Azure provider (если вдруг включишь) ===
export ARM_SKIP_PROVIDER_REGISTRATION="${ARM_SKIP_PROVIDER_REGISTRATION:-true}"
export ARM_SKIP_CREDENTIALS_VALIDATION="${ARM_SKIP_CREDENTIALS_VALIDATION:-true}"
export ARM_CLIENT_ID="${ARM_CLIENT_ID:-00000000-0000-0000-0000-000000000000}"
export ARM_TENANT_ID="${ARM_TENANT_ID:-00000000-0000-0000-0000-000000000000}"
export ARM_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID:-00000000-0000-0000-0000-000000000000}"

# === Создание директории для mock-файлов ===
mkdir -p .mock

# === Функция инициализации с обработкой backend ===
do_init() {
  echo "🔄 Инициализация Terraform..."
  
  # Проверяем, есть ли уже инициализация
  if [[ -d ".terraform" ]]; then
    echo "⚠️  Обнаружена существующая инициализация. Переконфигурирую backend..."
    terraform init -reconfigure -upgrade
  else
    echo "📦 Первая инициализация..."
    terraform init -upgrade
  fi
}

# === Команды ===
case "${1:-}" in
  init)
    do_init
    ;;
    
  plan)
    echo "📋 Генерация плана (mock-режим: use_azure_provider=$TF_VAR_use_azure_provider)..."
    # Авто-инит если нужно
    if [[ ! -d ".terraform" ]]; then
      do_init
    fi
    terraform plan -var-file=terraform.tfvars -out=tfplan
    ;;
    
  apply)
    echo "✅ Применение конфигурации (mock-режим)..."
    if [[ ! -d ".terraform" ]]; then
      do_init
    fi
    terraform apply -var-file=terraform.tfvars -auto-approve
    echo "✨ Mock-файлы созданы в .mock/"
    ;;
    
  destroy)
    echo "🗑️  Уничтожение ресурсов..."
    if [[ -d ".terraform" ]]; then
      terraform destroy -var-file=terraform.tfvars -auto-approve
    fi
    echo "🧹 Очистка mock-файлов..."
    rm -rf .mock/ tfplan terraform.tfstate.backup
    echo "✅ Готово"
    ;;
    
  validate)
    echo "🔍 Валидация конфигурации..."
    if [[ ! -d ".terraform" ]]; then
      do_init
    fi
    terraform validate
    ;;
    
  status)
    echo "📊 Состояние mock-ресурсов:"
    if [[ -d ".mock" ]]; then
      find .mock -type f -name "*.json" | while read f; do
        echo "  • $(basename "$f")"
      done
    else
      echo "  (пусто — выполните 'apply' для создания)"
    fi
    ;;
    
  help|--help|-h)
    show_help
    ;;
    
  *)
    echo "❌ Неизвестная команда: $1"
    echo ""
    show_help
    exit 1
    ;;
esac