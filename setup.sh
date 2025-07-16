#!/bin/bash

echo "🚀 Установка системы автоматического рецензирования научных статей"
echo "=================================================================="

# Проверка Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 не найден. Пожалуйста, установите Python 3.8+"
    exit 1
fi

echo "✅ Python найден: $(python3 --version)"

# Создание виртуального окружения
echo "📦 Создание виртуального окружения..."
python3 -m venv venv

# Активация виртуального окружения
echo "🔧 Активация виртуального окружения..."
source venv/bin/activate

# Установка зависимостей
echo "📚 Установка зависимостей..."
pip install --upgrade pip
pip install -r requirements.txt

# Создание директорий
echo "📁 Создание необходимых директорий..."
mkdir -p temp
mkdir -p models
mkdir -p logs

# Копирование примера конфигурации
if [ ! -f .env ]; then
    echo "⚙️ Создание файла конфигурации..."
    cp env.example .env
    echo "📝 Отредактируйте файл .env и укажите ваш BOT_TOKEN"
fi

# Проверка Ollama
echo "🔍 Проверка Ollama..."
if command -v ollama &> /dev/null; then
    echo "✅ Ollama найден"
    echo "📥 Попытка загрузки модели llama3.2:3b..."
    ollama pull llama3.2:3b
else
    echo "⚠️ Ollama не найден. Установите Ollama:"
    echo "   Linux/Mac: curl -fsSL https://ollama.com/install.sh | sh"
    echo "   Windows: https://ollama.com"
    echo "   Затем выполните: ollama pull llama3.2:3b"
fi

echo ""
echo "🎉 Установка завершена!"
echo ""
echo "📋 Следующие шаги:"
echo "1. Отредактируйте файл .env и укажите ваш BOT_TOKEN"
echo "2. Убедитесь, что Ollama запущен: ollama serve"
echo "3. Запустите бота: python бейзлайн/main.py"
echo ""
echo "📚 Подробная документация в README.md" 