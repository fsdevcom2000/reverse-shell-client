# 🇬🇧 Reverse Shell Client

A reverse shell client written in Nim programming language. The client connects to a remote server, receives commands, and executes them on the local machine.

## Features

- Automatic reconnection on connection loss
    
- Exponential backoff for reconnection attempts
    
- Command execution via Windows command line (`cmd.exe`)
    
- Special command handling (`exit`, `quit`)
    
- Timeout protection against hangs
    
- Timestamped logging for all operations
    

## Requirements

- Nim 2.2.6 or higher
    
- Nim compiler
    
- Windows operating system (cmd.exe commands supported)
    

## Installation

1. Install Nim: [https://nim-lang.org/install.html](https://nim-lang.org/install.html)
    
2. Clone the repository or download the source code
    
3. Build the project:
    
```shell
nim c -d:ssl --app:gui -d:release ShellClient.nim
```

Compilation options:

- `-d:ssl`: Enables SSL support (if needed)
    
- `--app:gui`: Creates a GUI application (no console)
    
- `-d:release`: Optimizes code for release version
    
Or

```
nim c -r ShellClient.nim
```
## Configuration

Before compilation, configure connection parameters in the source code:

```nim
let
  host = "10.10.10.1"  # Server IP address
  port = Port(443)      # Server port
  baseRetryDelay = 30.seconds  # Base reconnection delay
  maxRetryDelay = 300.seconds  # Maximum reconnection delay
```
## Usage

### Starting the Client

After compilation, run the executable:

`ShellClient.exe`

### Client Behavior

1. **Initial Delay**: Program waits a random time (45-75 seconds) before starting
    
2. **Connection**: Client attempts to connect to the specified server
    
3. **Operation**: After connection, client waits for commands from the server
    
4. **Reconnection**: On connection loss, client automatically reconnects
    

### Available Commands

- `exit` or `quit` - end the session
    
- Any Windows command line commands
    

## Security

### Warnings

⚠️ **IMPORTANT**: This tool is intended for legal use only:

- Testing security of your own systems
    
- Administration with explicit permission
    
- Educational purposes
    

### Precautions

1. Do not use for unauthorized access
    
2. Restrict use to trusted networks
    
3. Regularly update code to fix vulnerabilities
    
4. Use traffic encryption when working in unsecured networks
    

## Architecture

### Main Components

1. **Connection Module**: Manages network connections and reconnections
    
2. **Command Handler**: Executes received commands
    
3. **Reconnection Manager**: Exponential backoff for errors
    
4. **Logging**: Timestamped event recording
    

### Workflow Algorithm

Initial Delay → Connection → Loop:
  1. Receive command
  2. Execute command
  3. Send result
  4. On error → Reconnect
### Building for Testing

For debugging, build with debug information:

```
nim c -d:debug ShellClient.nim
```
## Troubleshooting

### Common Issues

1. **Cannot Connect**:
    
    - Check server availability
        
    - Ensure port is open in firewall
        
    - Verify IP address and port are correct
        
2. **Commands Not Executing**:
    
    - Check permissions
        
    - Ensure cmd.exe is available
        
    - Check logs for errors
        
3. **High CPU Usage**:
    
    - Increase delays between connection attempts
        
    - Add sleep in main loops
        

### Logging

All events are logged with timestamps. Example output:

```
[2024-01-15T10:30:00] Attempting to connect to 10.10.10.1:443...
[2024-01-15T10:30:05] Connected successfully
[2024-01-15T10:31:00] Executing command: dir
[2024-01-15T10:32:00] Connection lost. Reconnecting in 30 seconds...
```

---

**Note**: Always obtain explicit permission before testing any systems you do not own.

# 🇷🇺 Reverse Shell Client

Проект представляет собой клиент (reverse shell), написанный на языке Nim. Клиент подключается к удаленному серверу, получает команды и выполняет их на локальной машине.

## Возможности

- Автоматическое переподключение при потере соединения
    
- Экспоненциальная задержка при повторных попытках подключения
    
- Выполнение команд через командную строку Windows (`cmd.exe`)
    
- Обработка специальных команд (`exit`, `quit`)
    
- Защита от зависаний с помощью таймаутов
    
- Логирование всех операций с временными метками
    

## Требования

- Nim 2.2.6 или выше
    
- Компилятор Nim
    
- Операционная система Windows (поддерживаются команды cmd.exe)
    

## Установка

1. Установите Nim: [https://nim-lang.org/install.html](https://nim-lang.org/install.html)
    
2. Клонируйте репозиторий или скачайте исходный код
    
3. Соберите проект:
    

```shell
nim c -d:ssl --app:gui -d:release ShellClient.nim
```

Опции компиляции:

- `-d:ssl`: Включает поддержку SSL (если требуется)
- `--app:gui`: Создает GUI приложение (без консоли)
- `-d:release`: Оптимизирует код для релизной версии
 
 или
```shell
nim c -r ShellClient.nim
```

## Конфигурация

Перед компиляцией настройте параметры подключения в исходном коде:

```nim
let
  host = "10.10.10.1"  # IP-адрес сервера
  port = Port(443)      # Порт сервера
  baseRetryDelay = 30.seconds  # Базовая задержка переподключения
  maxRetryDelay = 300.seconds  # Максимальная задержка переподключения
```

## Использование

### Запуск клиента

После компиляции запустите полученный исполняемый файл:

`ShellClient.exe`

### Поведение клиента

1. **Начальная задержка**: Программа ждет случайное время (45-75 секунд) перед началом работы
    
2. **Подключение**: Клиент пытается подключиться к указанному серверу
    
3. **Работа**: После подключения клиент ожидает команды от сервера
    
4. **Переподключение**: При потере соединения клиент автоматически переподключается
    

### Доступные команды

- `exit` или `quit` - завершение сеанса
    
- Любые команды командной строки Windows
    

## Безопасность

### Предупреждения

⚠️ **ВАЖНО**: Этот инструмент предназначен только для легального использования:

- Тестирование безопасности собственных систем
    
- Администрирование с явного разрешения
    
- Образовательные цели
    

### Меры предосторожности

1. Не используйте для несанкционированного доступа
    
2. Ограничьте использование доверенными сетями
    
3. Используйте шифрование трафика при работе в незащищенных сетях
    

## Архитектура

### Основные компоненты

1. **Модуль подключения**: Управление сетевыми соединениями и переподключениями
    
2. **Обработчик команд**: Выполнение полученных команд
    
3. **Менеджер переподключений**: Экспоненциальная задержка при ошибках
    
4. **Логирование**: Запись событий с временными метками
    

### Алгоритм работы

Начальная задержка → Подключение → Цикл:
  1. Получить команду
  2. Выполнить команду
  3. Отправить результат
  4. При ошибке → Переподключение


### Сборка для тестирования

Для отладки соберите с отладочной информацией:

`nim c -d:debug ShellClient.nim`

## Устранение неисправностей

### Частые проблемы

1. **Не удается подключиться**:
    
    - Проверьте доступность сервера
        
    - Убедитесь, что порт открыт в фаерволе
        
    - Проверьте правильность IP-адреса и порта
        
2. **Команды не выполняются**:
    
    - Проверьте права доступа
        
    - Убедитесь, что cmd.exe доступен
        
    - Проверьте логи на наличие ошибок
        
3. **Высокое использование CPU**:
    
    - Увеличьте задержки между попытками подключения
        
    - Добавьте sleep в основные циклы
        

### Логирование

Все события логируются с временными метками. Пример вывода:

```
[2024-01-15T10:30:00] Attempting to connect to 10.10.10.1:443...
[2024-01-15T10:30:05] Connected successfully
[2024-01-15T10:31:00] Executing command: dir
[2024-01-15T10:32:00] Connection lost. Reconnecting in 30 seconds...
```

---

**Примечание**: Всегда получайте явное  разрешение перед тестированием любых систем, которые вам не принадлежат.
