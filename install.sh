apt update && apt full-upgrade -y && apt install xorg slim freerdp2-x11 ufw -y

echo "default_user	user" >> /etc/slim.conf
echo "auto_login	yes"  >> /etc/slim.conf

wget -o /home/user/xfreerdp2.sh https://raw.githubusercontent.com/mainuk18/debian10-xfreerdp2-client/main/xfreerdp2.sh -P /home/user/

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
ufw allow from 192.168.0.0/17 to any port 5900:5903 proto tcp
ufw enable

reboot
