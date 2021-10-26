#!/usr/bin/env bash
if [ "$USER" = "root" ]; then
	echo "must not run as root (nor use sudo)"
	exit 1
fi

FONTS=/usr/local/share/fonts
if [ ! -d $FONTS ]; then
	# We do not want to try to create a directory outside of $HOME or "/tmp".
	echo "directory does not exist: $FONTS"
	exit 1
fi

TAG=$(curl -s https://api.github.com/repos/be5invis/Iosevka/releases/latest | jq -r '.tag_name')
SANITIZED_TAG=$TAG
if [ "${TAG:0:1}" = "v" ]; then
	SANITIZED_TAG="${TAG:1}"
fi

ZIPFILE=/tmp/iosevka-$SANITIZED_TAG.zip
FONTFILE=/tmp/iosevka.ttc

function clean-tmp-files {
	if [ -f $ZIPFILE ]; then
		rm $ZIPFILE
	fi
	if [ -f $FONTFILE ]; then
		rm $FONTFILE
	fi
}

clean-tmp-files
wget -O $ZIPFILE https://github.com/be5invis/Iosevka/releases/download/$TAG/super-ttc-iosevka-$SANITIZED_TAG.zip
( cd /tmp; unzip $ZIPFILE )
sudo mv $FONTFILE $FONTS
sudo fc-cache
clean-tmp-files
