@echo off
chcp 65001 >nul

echo 🚀 Установка системы автоматического рецензирования научных статей
echo ==================================================================

REM Проверка Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python не найден. Пожалуйста, установите Python 3.8+
    pause
    exit /b 1
)

echo ✅ Python найден
python --version

REM Создание виртуального окружения
echo 📦 Создание виртуального окружения...
python -m venv venv

REM Активация виртуального окружения
echo 🔧 Активация виртуального окружения...
call venv\Scripts\activate.bat

REM Установка зависимостей
echo 📚 Установка зависимостей...
python -m pip install --upgrade pip
pip install -r requirements.txt

REM Создание директорий
echo 📁 Создание необходимых директорий...
if not exist temp mkdir temp
if not exist models mkdir models
if not exist logs mkdir logs

REM Копирование примера конфигурации
if not exist .env (
    echo ⚙️ Создание файла конфигурации...
    copy env.example .env
    echo 📝 Отредактируйте файл .env и укажите ваш BOT_TOKEN
)

REM Проверка Ollama
echo 🔍 Проверка Ollama...
ollama version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Ollama найден
    echo 📥 Попытка загрузки модели llama3.2:3b...
    ollama pull llama3.2:3b
) else (
    echo ⚠️ Ollama не найден. Скачайте и установите с https://ollama.com
    echo    Затем выполните: ollama pull llama3.2:3b
)

echo.
echo 🎉 Установка завершена!
echo.
echo 📋 Следующие шаги:
echo 1. Отредактируйте файл .env и укажите ваш BOT_TOKEN
echo 2. Убедитесь, что Ollama запущен
echo 3. Запустите бота: python бейзлайн/main.py
echo.
echo 📚 Подробная документация в README.md

pause 