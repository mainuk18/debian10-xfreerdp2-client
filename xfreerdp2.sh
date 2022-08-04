while :
do
if [[ $(pgrep xfreerdp) == ""  ]]
then
#       rdesktop -f -u '' -d dc -N -b -k en-us -a 24 -x l -r sound:local:alsa:default s3
xfreerdp \
+aero \
+auto-reconnect \
/auto-reconnect-max-retries:0 \
/cert-ignore \
-compression \
/d:dc \
/dynamic-resolution \
/f \
/bpp:32 \
-sec-nla \
/sec:tls \
/rfx-mode:image \
/u:'' \
/v:192.168.100.3:3389
fi
done
