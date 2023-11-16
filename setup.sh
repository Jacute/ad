#!/bin/bash


sudo apt update
sudo apt upgrade -y

sudo apt install net-tools -y
sudo apt install screen -y
sudo apt install git -y
sudo apt install python3 python3-pip -y

sudo apt install ca-certificates curl gnupg -y

sudo apt install docker-compose -y
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

cd ~
git clone https://github.com/DestructiveVoice/DestructiveFarm

pip3 install -r DestructiveFarm/server/requirements.txt

echo "CONFIG = {
    # Don't forget to remove the old database (flags.sqlite) before each competition.

    # The clients will run sploits on TEAMS and
    # fetch FLAG_FORMAT from sploits' stdout.
    'TEAMS': {'Team #{}'.format(i): '10.0.0.{}'.format(i)
              for i in range(1, 29 + 1)},
    'FLAG_FORMAT': r'[A-Z0-9]{31}=',

    # This configures how and where to submit flags.
    # The protocol must be a module in protocols/ directory.

    'SYSTEM_PROTOCOL': 'custom_http',
    'SYSTEM_URL': '192.168.0.139',
    'SYSTEM_PORT': 31337,

    # 'SYSTEM_PROTOCOL': 'ructf_http',
    # 'SYSTEM_URL': 'http://monitor.ructfe.org/flags',
    # 'SYSTEM_TOKEN': 'your_secret_token',

    # 'SYSTEM_PROTOCOL': 'volgactf',
    # 'SYSTEM_HOST': '127.0.0.1',

    # 'SYSTEM_PROTOCOL': 'forcad_tcp',
    # 'SYSTEM_HOST': '127.0.0.1',
    # 'SYSTEM_PORT': 31337,
    # 'TEAM_TOKEN': 'your_secret_token',

    # The server will submit not more than SUBMIT_FLAG_LIMIT flags
    # every SUBMIT_PERIOD seconds. Flags received more than
    # FLAG_LIFETIME seconds ago will be skipped.
    'SUBMIT_FLAG_LIMIT': 50,
    'SUBMIT_PERIOD': 5,
    'FLAG_LIFETIME': 5 * 60,

    # Password for the web interface. You can use it with any login.
    # This value will be excluded from the config before sending it to farm clients.
    'SERVER_PASSWORD': 'password',

    # Use authorization for API requests
    'ENABLE_API_AUTH': False,
    'API_TOKEN': '00000000000000000000'
}
" > DestructiveFarm/server/config.py

cd DestructiveFarm/server
echo "#!/bin/sh

# Use FLASK_DEBUG=True if needed

FLASK_APP=$(dirname $(readlink -f $0))/standalone.py python3 -m flask run --host 0.0.0.0 --port 56969 --with-threads
" > start_server.sh

cd ~
git clone --recurse-submodules https://gitlab.com/packmate/Packmate.git

echo "# Локальный IP сервера на указанном интерфейсе или в pcap файле
PACKMATE_LOCAL_IP=<local_ip>
# Имя пользователя для web-авторизации
PACKMATE_WEB_LOGIN=<login>
# Пароль для web-авторизации
PACKMATE_WEB_PASSWORD=<password>
# Режим работы - перехват
PACKMATE_MODE=LIVE
# Интерфейс, на котором производится перехват трафика
PACKMATE_INTERFACE=any" > Packmate/.env
