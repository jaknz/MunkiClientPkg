#!/bin/bash

if [ "$1" == "" ];then
	MANIFEST="baseline"
else
	MANIFEST="$1"
fi

if [ "$2" == "." ];then
	WORKDIR="."
else
	WORKDIR="~/Desktop"
fi

REPONAME="munki_repo"
HOSTNAME="munki.local"
VERSION="1.0"
USERNAME=$(who -m | awk {'print $1'})

echo "$HOSTNAME/$REPONAME/manifests/$MANIFEST"
rm -rf /tmp/ClientConfig/Library/Preferences/
mkdir -p /tmp/ClientConfig/Library/Preferences/
/usr/bin/defaults write /tmp/ClientConfig/Library/Preferences/ManagedInstalls.plist SoftwareRepoURL "$HOSTNAME/${REPONAME}"
/usr/bin/defaults write /tmp/ClientConfig/Library/Preferences/ManagedInstalls.plist ClientIdentifier "$MANIFEST"
/bin/chmod ug+rwX,o+rX-w /tmp/ClientConfig/Library/Preferences/ManagedInstalls.plist

#mkdir -p /tmp/ClientConfig/Users/Shared/
#chmod -R a+rwxt /tmp/ClientConfig/Users/Shared/
#touch /tmp/ClientConfig/Users/Shared/.com.googlecode.munki.checkandinstallatstartup

rm -f "$WORKDIR"/"ClientConfig_mags_$MANIFEST".pkg
/usr/bin/pkgbuild --version "$VERSION" --identifier nz.school.mags.munki."$MANIFEST" --root /tmp/ClientConfig "$WORKDIR"/"ClientConfig_mags_$MANIFEST".pkg
/usr/sbin/chown -R $USERNAME "$WORKDIR"/"ClientConfig_mags_$MANIFEST".pkg
rm -rf /tmp/ClientConfig

exit 0
