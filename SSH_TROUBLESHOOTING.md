# 🔧 Устранение проблем с SSH подключением

## ❌ Проблема: `ssh: connect to host 158.160.46.251 port 22: Operation timed out`

### 🔍 Диагностика

#### 1. Проверка доступности сервера
```bash
# Проверяем, отвечает ли сервер на ping
ping 158.160.46.251

# Проверяем доступность порта SSH
telnet 158.160.46.251 22
# или
nc -zv 158.160.46.251 22
```

#### 2. Проверка через веб-интерфейс Yandex Cloud
1. Войдите в [Yandex Cloud Console](https://console.cloud.yandex.ru/)
2. Перейдите в раздел "Compute Cloud" → "Виртуальные машины"
3. Найдите вашу ВМ и проверьте:
   - ✅ **Статус**: должен быть "RUNNING"
   - ✅ **Внешний IP**: должен совпадать с 158.160.46.251
   - ✅ **SSH доступ**: должен быть включен

### 🛠️ Решения

#### Решение 1: Проверка статуса ВМ
```bash
# Если у вас установлен Yandex Cloud CLI
yc compute instance list
yc compute instance get <instance-id>
```

#### Решение 2: Перезагрузка ВМ через консоль
1. В веб-консоли Yandex Cloud найдите вашу ВМ
2. Нажмите "Остановить" → дождитесь остановки → "Запустить"
3. Подождите 2-3 минуты после запуска

#### Решение 3: Проверка Security Groups (Firewall)
1. В консоли перейдите к настройкам ВМ
2. Проверьте "Группы безопасности"
3. Убедитесь, что есть правило:
   - **Направление**: Входящий трафик
   - **Протокол**: TCP
   - **Порт**: 22
   - **Источник**: 0.0.0.0/0 (или ваш IP)

#### Решение 4: Альтернативные способы подключения

##### Через веб-консоль (Serial Console)
1. В настройках ВМ включите "Доступ к серийной консоли"
2. Подключитесь через веб-интерфейс
3. Проверьте SSH сервис:
```bash
sudo systemctl status ssh
sudo systemctl start ssh
sudo systemctl enable ssh
```

##### Через другой порт SSH
```bash
# Попробуйте подключиться к альтернативным портам
ssh -p 2222 ubuntu@158.160.46.251
ssh -p 2200 ubuntu@158.160.46.251
```

#### Решение 5: Использование SSH ключей
```bash
# Если нужны SSH ключи, создайте их
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Попробуйте подключиться с указанием ключа
ssh -i ~/.ssh/id_rsa ubuntu@158.160.46.251

# Или с другим пользователем
ssh -i ~/.ssh/id_rsa root@158.160.46.251
ssh -i ~/.ssh/id_rsa yc-user@158.160.46.251
```

#### Решение 6: Проверка сетевых настроек
```bash
# Трассировка маршрута
traceroute 158.160.46.251

# Проверка DNS
nslookup 158.160.46.251

# Проверка с разных сетей
# Попробуйте подключиться с мобильного интернета или VPN
```

### 🔄 Создание новой ВМ (если ничего не помогает)

#### Через Yandex Cloud CLI
```bash
# Установка CLI (если не установлен)
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
exec -l $SHELL

# Инициализация
yc init

# Создание новой ВМ
yc compute instance create \
  --name rutub-vm \
  --zone ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,size=20GB \
  --ssh-key ~/.ssh/id_rsa.pub \
  --cores 2 \
  --memory 4GB
```

#### Через веб-интерфейс
1. Войдите в [Yandex Cloud Console](https://console.cloud.yandex.ru/)
2. "Создать ресурс" → "Виртуальная машина"
3. Настройки:
   - **Образ**: Ubuntu 20.04 LTS
   - **vCPU**: 2
   - **RAM**: 4 ГБ
   - **Диск**: 20 ГБ SSD
   - **Публичный IP**: Да
   - **SSH ключ**: Вставьте ваш публичный ключ

### 📱 Альтернативные способы развертывания

#### Вариант 1: Использование Docker на локальной машине
```bash
cd Рутуб

# Создайте .env файл
echo "BOT_TOKEN=your_bot_token" > .env

# Запустите локально для тестирования
docker-compose -f docker-compose.vm.yml up -d
```

#### Вариант 2: Использование других облачных провайдеров
- **DigitalOcean**: простой в настройке
- **AWS EC2**: бесплатный tier
- **Google Cloud**: $300 кредитов для новых пользователей
- **Hetzner**: недорогие VPS

### 🆘 Экстренные действия

#### Если нужно срочно запустить бота
```bash
# Запустите бота локально на вашем компьютере
cd Рутуб
export BOT_TOKEN="your_telegram_bot_token"
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Запустите Ollama локально (в отдельном терминале)
ollama serve
ollama pull llama3.2:3b

# Запустите бота
python main.py
```

### 📞 Получение помощи

#### Информация для диагностики
Соберите следующую информацию:
```bash
# Ваша операционная система
uname -a

# Версия SSH клиента
ssh -V

# Результат ping
ping -c 4 158.160.46.251

# Трассировка
traceroute 158.160.46.251

# Проверка портов
nmap -p 22,80,443,8000 158.160.46.251
```

#### Команды для проверки в Yandex Cloud
```bash
# Список ВМ
yc compute instance list

# Информация о конкретной ВМ
yc compute instance get --name rutub-vm

# Логи
yc logging read --group-id <log-group-id>
```

### ✅ Чек-лист проверки

- [ ] ВМ в статусе "RUNNING"
- [ ] Внешний IP правильный
- [ ] Порт 22 открыт в Security Groups
- [ ] SSH сервис запущен на ВМ
- [ ] SSH ключи настроены
- [ ] Нет блокировки на уровне провайдера
- [ ] Интернет подключение стабильно

### 🎯 После решения проблемы

Когда SSH заработает:
1. Сразу обновите систему: `sudo apt update && sudo apt upgrade -y`
2. Установите необходимые компоненты
3. Настройте firewall: `sudo ufw enable && sudo ufw allow ssh`
4. Продолжите с инструкции `DEPLOY_TO_VM.md` 