#!/bin/bash

# in-depth check to ensure we are running on NX1 (v1.40) or on NX500 (v1.11)
isNX1=$(/bin/grep   ^NX1$   /etc/version.info &>/dev/null && \
  /bin/grep ^1.40$ /etc/version.info &>/dev/null; echo $?)
isNX500=$(/bin/grep ^NX500$ /etc/version.info &>/dev/null && \
  /bin/grep ^1.11$ /etc/version.info &>/dev/null; echo $?)

if [ $isNX1 -eq 0 -o $isNX500 -eq 0 ]; then
  if [ ! -x /usr/sbin/bluetoothd.orig ]; then
      # sdcard run file mod NOT already installed 
      # thanks to Otto
    mount -o remount,rw /
    cd /usr/sbin/
    mv bluetoothd bluetoothd.orig
    cat >bluetoothd << EOF
#!/bin/bash
if [ -x /opt/storage/sdcard/scripts/init.sh ];
then
  /opt/storage/sdcard/scripts/init.sh &
fi
/usr/sbin/bluetoothd.orig -d
EOF
    chmod +x bluetoothd
    sync;sync;sync
    mount -o remount,ro /
    mv /opt/storage/sdcard/info.tg /opt/storage/sdcard/info.tg-done
  fi
fi
mv /opt/storage/sdcard/info.tg /opt/storage/sdcard/info.tg-done
killall dfmsd
