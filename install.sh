apt update && apt full-upgrade -y && apt install xorg slim freerdp2-x11 x11vnc ufw -y

sed -i "s|#default_user\s* .*|default_user        user|i" /etc/slim.conf && \
sed -i "s|#auto_login\s* .*|auto_login          yes|i" /etc/slim.conf

sed -i "s|#Port\s*22.*|Port 22|i" /etc/sshd/sshd_config
sed -i "s|#AddressFamily\s*any.*|AddressFamily inet|i" /etc/sshd/sshd_config
sed -i "s|#HostKey\s*ed25519.*|HostKey /etc/ssh/ssh_host_ed25519_key|i" /etc/sshd/sshd_config
sed -i "s|#IgnoreRHosts\s* .*|IgnoreRHosts yes|i" /etc/sshd/sshd_config
sed -i "s|#PermitRootLogin\s* .*|PermitRootLogin yes|i" /etc/sshd/sshd_config
sed -i "s|#UseDNS\s* .*|UseDNS no|i" /etc/sshd/sshd_config

wget -O /home/user/xfreerdp2.sh https://raw.githubusercontent.com/mainuk18/debian10-xfreerdp2-client/main/xfreerdp2.sh -P /home/user/
chmod +x /home/user/xfreerdp2.sh

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
# Отключаем режим энергосбережения
setterm -powersave off
# Запустим XFreeRDP2-X11
exec /home/user/xfreerdp2.sh
EOF
"

chown user /home/user/.xsession

ufw default deny incoming
ufw default allow outgoing
ufw allow from 192.168.0.0/17 to any port ssh
ufw allow from 192.168.0.0/17 to any port 5900 proto tcp
ufw enable

reboot
