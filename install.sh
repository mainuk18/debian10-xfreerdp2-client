sed -i "s|deb cdrom\s*.*||i" /etc/apt/sources.list

echo "deb https://deb.debian.org/debian buster-backports main contrib non-free" > /etc/apt/sources.list.d/buster-backports.list

#apt update && apt full-upgrade -y && apt install xorg slim rdesktop x11vnc net-tools alsa-utils ufw -y
apt update && apt full-upgrade -y && apt install xorg slim rdesktop x11vnc net-tools alsa-utils numlockx -y
apt install -t buster-backports linux-image-5.10.0-0.deb.10.16-rt-*

sed -i "s|#default_user\s* .*|default_user        user|i" /etc/slim.conf && \
sed -i "s|#auto_login\s* .*|auto_login          yes|i" /etc/slim.conf

sed -i "s|#Port\s*22.*|Port 22|i" /etc/ssh/sshd_config
sed -i "s|#AddressFamily\s*any.*|AddressFamily inet|i" /etc/ssh/sshd_config
sed -i "s|#HostKey\s*ed25519.*|HostKey /etc/ssh/ssh_host_ed25519_key|i" /etc/ssh/sshd_config
sed -i "s|#IgnoreRHosts\s* .*|IgnoreRHosts yes|i" /etc/ssh/sshd_config
sed -i "s|#PermitRootLogin\s* .*|PermitRootLogin yes|i" /etc/ssh/sshd_config
sed -i "s|#UseDNS\s* .*|UseDNS no|i" /etc/ssh/sshd_config

#sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT\s*=.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"|i' /etc/default/grub
sed -i "s|GRUB_TIMEOUT\s*=.*|GRUB_TIMEOUT=0|i" /etc/default/grub
update-grub

wget -O /home/user/rdp.sh https://raw.githubusercontent.com/mainuk18/debian10-xfreerdp2-client/main/rdp.sh -P /home/user/
chmod +x /home/user/rdp.sh

/usr/bin/sh -c "cat > /home/user/.xsession <<EOF
# Укажем предпочтительный язык для интерфейса системы и приложений
# Удали эти строки, если предпочитаешь английский язык
export LANG=ru_RU.utf8
export LC_ALL=ru_RU.utf8
# Настроим переключатель раскладки между русским и английским по клавише SHIFT+ALT
setxkbmap "us,ru" ",winkeys" "grp:alt_shift_toggle"
# Отключим раздражающий бибикающий звук
xset b off
# Отключаем экранную заставку
xset s off
# Включаем numlock
numlockx on
# Отключаем режим энергосбережения
setterm -powersave off
# Запустим RDesktop
exec /home/user/rdp.sh
EOF
"

chown user /home/user/.xsession

x11vnc -storepasswd /etc/x11vnc.passwd
chmod 0400 /etc/x11vnc.passwd
chown user /etc/x11vnc.passwd

/usr/bin/sh -c "cat > /lib/systemd/system/x11vnc.service <<EOF
[Unit]
Description=Start x11vnc
After=multi-user.target

[Service]
User=user
Group=user
Type=simple
ExecStart=/usr/bin/x11vnc -display :0 -auth guess -forever -loop -noxdamage -repeat -rfbauth /etc/x11vnc.passwd -rfbport 5900 -shared

[Install]
WantedBy=multi-user.target
EOF
"

systemctl enable x11vnc.service

#ufw default deny incoming
#ufw default allow outgoing
#ufw allow from 192.168.0.0/17 to any port ssh
#ufw allow from 192.168.0.0/17 to any port 5900 proto tcp
#ufw enable

reboot
