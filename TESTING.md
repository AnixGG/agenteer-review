# 🧪 Система тестирования бота

Комплексная система тестирования для Telegram бота анализа научных статей.

## 📋 Обзор системы тестирования

### Типы тестов

1. **🏠 Локальные тесты** (`test_local.py`) - быстрые тесты для разработки
2. **🔬 Unit тесты** - тестирование отдельных компонентов
3. **🔗 Integration тесты** - тестирование взаимодействия компонентов
4. **🚀 Deployment тесты** - тестирование деплоя и сервисов
5. **🎯 End-to-End тесты** - полное тестирование функциональности
6. **🆕 Тесты новых агентов** (`test_new_agent.py`) - для новых компонентов

### Структура файлов

```
📁 Тестирование/
├── test_local.py              # Быстрые локальные тесты
├── test_deployment.py         # Полная система тестирования
├── test_new_agent.py          # Тесты для новых агентов
├── update_deployment.sh       # Скрипт автоматического обновления
├── .pre-commit-config.yaml    # Pre-commit hooks
├── .github/workflows/         # CI/CD пайплайны
└── TESTING.md                 # Это руководство
```

## 🏃‍♂️ Быстрый старт

### Локальная разработка

```bash
# Быстрые тесты перед коммитом
python test_local.py

# Тестирование новых агентов
python test_new_agent.py

# Полное локальное тестирование
python test_deployment.py --quick
```

### Тестирование деплоя

```bash
# Полные тесты деплоя
python test_deployment.py

# Только unit тесты
python test_deployment.py --unit-only

# Только deployment тесты
python test_deployment.py --deployment-only
```

### Обновление на ВМ

```bash
# Автоматическое обновление
./update_deployment.sh

# Обновление только бота
./update_deployment.sh bot-only

# Обновление с полными тестами
./update_deployment.sh full-test
```

## 📖 Детальное руководство

### 1. Локальные тесты (`test_local.py`)

**Назначение:** Быстрые проверки во время разработки

**Что тестируется:**
- ✅ Импорты всех модулей
- ✅ Конфигурация системы
- ✅ Структура файлов
- ✅ Зависимости Python
- ✅ Базовая функциональность компонентов

**Использование:**
```bash
# Запуск локальных тестов
python test_local.py

# Время выполнения: ~10-30 секунд
```

**Пример вывода:**
```
🏠 Запуск локальных тестов для разработки
==================================================
✅ Core imports
✅ Configuration
✅ File structure
✅ Dependencies
✅ PDF extractor basic
✅ Structure agent basic
✅ Orchestrator basic
✅ Bot handlers import
✅ LLM service import

==================================================
📊 РЕЗУЛЬТАТЫ ЛОКАЛЬНОГО ТЕСТИРОВАНИЯ
==================================================
✅ Все тесты пройдены: 9/9 за 15.23s
🎉 Код готов для коммита!
==================================================
```

### 2. Полная система тестирования (`test_deployment.py`)

**Назначение:** Комплексное тестирование всех аспектов системы

**Что тестируется:**

#### Unit тесты:
- Импорты модулей
- PDF экстрактор
- Структурный агент
- Оркестратор

#### Integration тесты:
- Пайплайн оркестратора
- Health checks компонентов

#### Deployment тесты:
- Состояние Docker контейнеров
- Доступность LLM сервиса
- API endpoints
- Использование ресурсов

#### End-to-End тесты:
- Полная обработка научной статьи
- Генерация рецензии

**Использование:**
```bash
# Все тесты
python test_deployment.py

# Только unit тесты
python test_deployment.py --unit-only

# Быстрый режим (без deployment/E2E)
python test_deployment.py --quick

# Только deployment тесты
python test_deployment.py --deployment-only
```

### 3. Тесты новых агентов (`test_new_agent.py`)

**Назначение:** Автоматическое тестирование новых агентов

**Что тестируется:**
- ✅ Импорт новых модулей агентов
- ✅ Создание экземпляров
- ✅ Наличие метода `analyze`
- ✅ Регистрация в оркестраторе
- ✅ Функциональность анализа

**Использование:**
```bash
# Автоматически находит и тестирует новые агенты
python test_new_agent.py
```

**Пример добавления нового агента:**
```bash
# 1. Создаем новый агент
touch core/agents/citation_agent.py

# 2. Реализуем агента
cat > core/agents/citation_agent.py << 'EOF'
from .base_agent import BaseAgent

class CitationAgent(BaseAgent):
    async def analyze(self, text, metadata):
        # Логика анализа цитирований
        return {"citations_count": 10, "quality": "good"}
EOF

# 3. Тестируем
python test_new_agent.py

# 4. Обновляем деплой
./update_deployment.sh bot-only
```

### 4. Автоматическое обновление (`update_deployment.sh`)

**Назначение:** Безопасное обновление деплоя с автоматическим откатом

**Возможности:**
- 🔄 Создание backup образов
- 📦 Обновление кода из Git
- 🏗️ Сборка и push образов
- 🚀 Обновление сервисов
- 🔍 Health checks
- 🧪 Автоматическое тестирование
- ↩️ Откат при ошибках

**Режимы работы:**
```bash
./update_deployment.sh              # Полное обновление
./update_deployment.sh bot-only     # Только бот
./update_deployment.sh llm-only     # Только LLM сервис
./update_deployment.sh full-test    # С полными тестами
```

## 🔄 CI/CD пайплайн

### GitHub Actions (`.github/workflows/test-and-deploy.yml`)

Автоматический пайплайн включает:

1. **🔬 Unit & Integration Tests**
   - Установка Python и зависимостей
   - Запуск локальных тестов
   - Unit тестирование

2. **🐳 Docker Build Test**
   - Сборка Docker образов
   - Проверка импортов в контейнерах

3. **🔗 Integration Test with Docker**
   - Запуск сервисов в Docker Compose
   - Health checks
   - Integration тестирование

4. **🆕 New Agents Test**
   - Автоматическое тестирование новых агентов

5. **🚀 Deploy to Production**
   - Сборка и push в Registry
   - Тегирование версий

6. **📢 Notification**
   - Уведомления о результатах

### Triggers

- **Push в main/develop:** Полный пайплайн
- **Pull Request:** Тестирование без деплоя
- **Manual:** Возможность ручного запуска

## 🔧 Pre-commit hooks

### Установка

```bash
# Установка pre-commit
pip install pre-commit

# Установка hooks
pre-commit install

# Запуск на всех файлах
pre-commit run --all-files
```

### Что проверяется

- **Форматирование:** black, isort
- **Линтинг:** flake8
- **Безопасность:** bandit
- **Качество кода:** различные проверки
- **Локальные тесты:** автоматический запуск
- **Docker syntax:** проверка Dockerfile

## 📊 Мониторинг и метрики

### Health Checks

```bash
# LLM сервис
curl http://localhost:8000/health

# Статус контейнеров
docker-compose -f docker-compose.production.yml ps

# Использование ресурсов
docker stats
```

### Логи

```bash
# Логи бота
docker-compose -f docker-compose.production.yml logs -f telegram-bot

# Логи LLM сервиса
docker-compose -f docker-compose.production.yml logs -f llm-service

# Поиск ошибок
docker-compose -f docker-compose.production.yml logs | grep -i error
```

## 🚨 Troubleshooting

### Частые проблемы

#### 1. Тесты не проходят локально

```bash
# Проверка зависимостей
pip install -r requirements.txt

# Проверка окружения
python test_local.py

# Проверка импортов
python -c "from core.orchestrator import Orchestrator; print('OK')"
```

#### 2. Docker тесты не работают

```bash
# Проверка Docker
docker --version
docker-compose --version

# Очистка
docker system prune -f

# Пересборка образов
docker build --no-cache -t test-bot -f Dockerfile.bot .
```

#### 3. LLM сервис недоступен

```bash
# Проверка портов
netstat -tulpn | grep :8000

# Проверка Ollama
docker exec -it llm-service ollama list

# Перезапуск сервиса
docker-compose restart llm-service
```

#### 4. Новые агенты не распознаются

```bash
# Проверка структуры
ls -la core/agents/

# Проверка класса
python -c "from core.agents.your_agent import YourAgent; print('OK')"

# Принудительное тестирование
python test_new_agent.py
```

### Откат при проблемах

```bash
# Автоматический откат в update_deployment.sh
# Или ручной откат:

# Остановка сервисов
docker-compose -f docker-compose.production.yml down

# Возврат к backup образам
docker tag cr.yandex/crphvdf8t7v4bpqnv3g5/telegram-bot:backup-TIMESTAMP cr.yandex/crphvdf8t7v4bpqnv3g5/telegram-bot:latest

# Запуск предыдущей версии
docker-compose -f docker-compose.production.yml up -d
```

## 📝 Примеры использования

### Пример 1: Добавление нового агента

```bash
# 1. Создание агента
mkdir -p core/agents
cat > core/agents/quality_agent.py << 'EOF'
from .base_agent import BaseAgent

class QualityAgent(BaseAgent):
    async def analyze(self, text, metadata):
        # Анализ качества статьи
        return {
            "clarity_score": 0.85,
            "completeness_score": 0.90,
            "recommendations": ["Improve introduction", "Add more examples"]
        }
EOF

# 2. Тестирование
python test_new_agent.py

# 3. Локальные тесты
python test_local.py

# 4. Коммит (с pre-commit hooks)
git add core/agents/quality_agent.py
git commit -m "Add QualityAgent for paper quality analysis"

# 5. Обновление деплоя
./update_deployment.sh bot-only
```

### Пример 2: Отладка проблем

```bash
# 1. Быстрая диагностика
python test_local.py

# 2. Полная диагностика
python test_deployment.py

# 3. Проверка конкретного компонента
python -c "
from core.agents.structure_agent import StructureAgent
import asyncio

async def test():
    agent = StructureAgent()
    result = await agent.analyze('test', {})
    print(result)

asyncio.run(test())
"

# 4. Проверка деплоя
curl http://localhost:8000/health
docker-compose ps
```

### Пример 3: Обновление с новыми зависимостями

```bash
# 1. Обновление requirements.txt
echo "new-package==1.0.0" >> requirements.txt

# 2. Локальное тестирование
pip install -r requirements.txt
python test_local.py

# 3. Обновление с полной пересборкой
./update_deployment.sh full-test

# 4. Проверка после деплоя
python test_deployment.py --deployment-only
```

## 🎯 Best Practices

### Для разработчиков

1. **Всегда запускайте локальные тесты** перед коммитом
2. **Используйте pre-commit hooks** для автоматических проверок
3. **Тестируйте новые агенты** немедленно после создания
4. **Пишите осмысленные commit сообщения**
5. **Проверяйте логи** после обновления

### Для деплоя

1. **Всегда создавайте backup** перед обновлением
2. **Используйте автоматический скрипт** обновления
3. **Мониторьте health checks** после деплоя
4. **Проверяйте метрики** и логи
5. **Будьте готовы к откату** при проблемах

### Для тестирования

1. **Запускайте разные типы тестов** в зависимости от изменений
2. **Используйте быстрые тесты** для итеративной разработки
3. **Полные тесты** только перед важными релизами
4. **Автоматизируйте проверки** через CI/CD
5. **Документируйте проблемы** и их решения

## 🆘 Поддержка

При возникновении проблем:

1. **Проверьте логи** и результаты тестов
2. **Используйте troubleshooting** секцию этого руководства
3. **Запустите диагностику** с помощью тестовых скриптов
4. **Сделайте откат** при критических проблемах
5. **Обратитесь за помощью** с подробным описанием проблемы

---

**🎉 Удачного тестирования и стабильного деплоя!** 