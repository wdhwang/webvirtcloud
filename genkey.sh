#!/bin/bash

readonly APP_NAME="webvirtcloud"
readonly APP_PATH="/srv/$APP_NAME"
readonly PYTHON="python3"

generate_secret_key() {
  "$PYTHON" - <<END
import random
print(''.join(random.SystemRandom().choice('abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)') for i in range(50)))
END
}

echo "* Configuring settings.py file."
cp "$APP_PATH/webvirtcloud/settings.py.template" "$APP_PATH/webvirtcloud/settings.py"

if [ -e "/etc/timezone" ] ; then
    tzone=\'$(cat /etc/timezone)\'
else
    tzone=\'$(Asia/Taipei)\'
fi
secret_key=$(generate_secret_key)
echo "* Secret for Django generated: $secret_key"
novncd_port=6080
novncd_public_port=6080
novncd_host="0.0.0.0"

sed -i "s|^\\(TIME_ZONE = \\).*|\\1$tzone|" "$APP_PATH/webvirtcloud/settings.py"
sed -i "s|^\\(SECRET_KEY = \\).*|\\1\'$secret_key\'|" "$APP_PATH/webvirtcloud/settings.py"
sed -i "s|^\\(WS_PORT = \\).*|\\1$novncd_port|" "$APP_PATH/webvirtcloud/settings.py"
sed -i "s|^\\(WS_PUBLIC_PORT = \\).*|\\1$novncd_public_port|" "$APP_PATH/webvirtcloud/settings.py"
sed -i "s|^\\(WS_HOST = \\).*|\\1\'$novncd_host\'|" "$APP_PATH/webvirtcloud/settings.py"

