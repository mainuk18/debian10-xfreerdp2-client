#!/bin/bash

#xrandr --newmode "1440x900_60.00"  106.50  1440 1528 1672 1904  900 903 909 934 -hsync +vsync
#xrandr --addmode VGA1 1440x900_60.00
#xrandr --output VGA1 --mode 1440x900_60.00

while :
do
    if [[ $(pgrep rdesktop) == ""  ]]
    then
#       rdesktop -f -u '' -d dc -N -b -k en-us -a 24 -x l -r sound:local:alsa:default -z s3
        rdesktop -f -u '' -d dc -N -P -k en-us -a 24 -x l -r sound:local:alsa:default s3
# -r scard:"EZCCID Smart Card Reader 00 00"="EZCCID Smart Card Reader"
    fi
done
