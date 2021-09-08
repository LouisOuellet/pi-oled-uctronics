#!/usr/bin/env bash

apt-get install -y build-essential make

sourceDir=$(dirname $(readlink -f $0))

if [ -f "/etc/rc.local"]; then
  echo "
cd ${sourceDir}/C
./display &" >> /etc/rc.local
  chmod +x /etc/rc.local
else
  echo "#!/bin/bash
cd ${sourceDir}/C
./display &" > /etc/rc.local
  chmod +x /etc/rc.local
fi

if [ ! -f "/etc/systemd/system/rc-local.service"]; then
  echo "[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/rc-local.service
  systemctl enable rc-local
  systemctl start rc-local
fi
