# Развертывание бота в Yandex Cloud

## ✅ Выполненные шаги

### 1. Подготовка инфраструктуры
- ✅ Установлен и настроен Yandex Cloud CLI
- ✅ Создан Container Registry (`my-registry`)
- ✅ Создан сервисный аккаунт `k8s-service-account` с необходимыми ролями
- ✅ Создан Managed Kubernetes кластер `my-cluster`

### 2. Контейнеризация
- ✅ Создан `Dockerfile.bot` для Telegram бота
- ✅ Создан `Dockerfile.llm` для LLM сервиса
- ✅ Создан `bot_service.py` - отдельный сервис бота
- ✅ Создан `llm_service.py` - FastAPI сервис для LLM
- ✅ Образы собраны и загружены в Container Registry

### 3. Kubernetes манифесты
- ✅ `k8s/llm-deployment.yaml` - развертывание LLM сервиса
- ✅ `k8s/bot-deployment.yaml` - развертывание бота
- ✅ `k8s/create-secrets.sh` - скрипт создания секретов
- ✅ `deploy.sh` - главный скрипт развертывания

## 🔄 Статус развертывания

**Кластер Kubernetes:** В процессе создания (PROVISIONING)
- Кластер ID: `catbofogp40ugvpr3mvc`
- Зона: `ru-central1-a`
- Версия: `1.29`

## 📋 Следующие шаги

### 1. Дождитесь готовности кластера
```bash
# Проверить статус кластера
yc managed-kubernetes cluster get --name my-cluster --format json | jq -r .status
```

Кластер должен быть в статусе `RUNNING`.

### 2. Получите токен вашего Telegram бота
Если у вас еще нет бота:
1. Напишите @BotFather в Telegram
2. Создайте нового бота командой `/newbot`
3. Сохраните полученный токен

### 3. Установите токен бота
```bash
export BOT_TOKEN="your_bot_token_here"
```

### 4. Запустите развертывание
```bash
./deploy.sh
```

## 🏗️ Архитектура

### Компоненты:
1. **Telegram Bot** (2 реплики)
   - Обрабатывает сообщения пользователей
   - Отправляет запросы к LLM сервису
   - Автомасштабирование: 2-10 экземпляров

2. **LLM Service** (1 реплика)
   - FastAPI сервис с Ollama
   - Модель: `llama3.2:3b`
   - Анализ научных статей

### Ресурсы:
- **Bot**: 512Mi-1Gi RAM, 0.5-1 CPU
- **LLM**: 4-8Gi RAM, 2-4 CPU

## 🔍 Мониторинг

### Проверка состояния
```bash
# Статус подов
kubectl get pods

# Логи бота
kubectl logs -f deployment/telegram-bot

# Логи LLM сервиса
kubectl logs -f deployment/llm-service

# Статус сервисов
kubectl get services
```

### Масштабирование
```bash
# Изменить количество экземпляров бота
kubectl scale deployment telegram-bot --replicas=5

# Проверить автомасштабирование
kubectl get hpa
```

## 🛠️ Отладка

### Подключение к поду
```bash
# Подключиться к боту
kubectl exec -it deployment/telegram-bot -- /bin/bash

# Подключиться к LLM сервису
kubectl exec -it deployment/llm-service -- /bin/bash
```

### Обновление образов
```bash
# Пересобрать и загрузить образ бота
docker build -t cr.yandex/crphvdf8t7v4bpqnv3g5/telegram-bot:latest -f Dockerfile.bot .
docker push cr.yandex/crphvdf8t7v4bpqnv3g5/telegram-bot:latest

# Обновить развертывание
kubectl rollout restart deployment/telegram-bot
```

## 📊 Структура файлов

```
📁 Рутуб/
├── 📁 k8s/
│   ├── llm-deployment.yaml      # Манифест LLM сервиса
│   ├── bot-deployment.yaml      # Манифест бота
│   └── create-secrets.sh        # Создание секретов
├── Dockerfile.bot              # Образ бота
├── Dockerfile.llm              # Образ LLM сервиса
├── bot_service.py              # Сервис бота
├── llm_service.py              # FastAPI LLM сервис
├── deploy.sh                   # Главный скрипт развертывания
└── DEPLOYMENT.md               # Эта инструкция
```

## 🎯 Готовность к использованию

После успешного развертывания:
1. Бот будет доступен в Telegram
2. Пользователи смогут отправлять PDF статьи
3. Бот будет автоматически анализировать и рецензировать статьи
4. Система будет автоматически масштабироваться при нагрузке

## 🔧 Настройка домена (опционально)

Для доступа к LLM API извне можно настроить Ingress:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: llm-ingress
spec:
  rules:
  - host: api.yourdomain.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: llm-service
            port:
              number: 8000
``` 