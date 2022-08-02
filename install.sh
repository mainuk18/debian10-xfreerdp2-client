apt update && apt full-upgrade -y && apt install xorg slim freerdp2-x11 ufw -y

echo "default_user	user" >> /etc/slim.conf
echo "auto_login	yes"  >> /etc/slim.conf

/usr/bin/sh -c "cat > /home/user/xfreerdp2.sh <<EOF
#!/usr/bin/sh
while :
do
    if [[ $(pgrep xfreerdp) == ""  ]]
    then
        xfreerdp \
          +aero \
          +auto-reconnect \
          /auto-reconnect-max-retries:0 \
          /cert-ignore \
          -compression \
          /d:dc \
          -decorations \
          /dynamic-resolution \
          /f \
          /rfx \
          /video \
          -sec-nla \
          /sec:tls \
          /rfx-mode:image \
          /u:'' \
          /v:192.168.100.3:3389
# -r scard:"EZCCID Smart Card Reader 00 00"="EZCCID Smart Card Reader"
    fi
done
EOF
"

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
