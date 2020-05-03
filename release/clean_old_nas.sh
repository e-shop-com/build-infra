#!/bin/bash

LATESTBUILDS=${1-/home/couchbase/latestbuilds}

remove_glob() {
  glob=$1
  days=$2
  echo Removing ${glob} older than ${days} days...
  find . -name ${glob} -atime +${days} -exec sh -c 'echo > "{}"; rm "{}"' \;
}

echo @@@@@@@@@
echo Clean up Couchbase Server toy builds
echo @@@@@@@@@
cd ${LATESTBUILDS}/couchbase-server/toybuilds

remove_glob "*.*" 15
echo "Removing empty toy build directories - ignore errors"
rmdir * || true

echo @@@@@@@@@
echo Clean up Couchbase Server
echo @@@@@@@@@
cd ${LATESTBUILDS}/couchbase-server

# All Windows ".bits" files older than 1 day (only needed for intra-build
# communication)
remove_glob "*windows_amd64-bits.tar" 1

# All MacOS .orig files from codesigning
remove_glob "*macos*.orig" 2

# All debug packages older than 15 days
remove_glob "*debug*" 15
remove_glob "*dbg*" 15
remove_glob "*-PDB.zip" 15

# All Ubuntu 12/14, Debian 8, Centos 6, Suse, Mac, "oel", and Windows builds
# older than 15/30 days
remove_glob "*amzn2*.rpm" 15
remove_glob "*macos*.zip*" 15
remove_glob "*macos*.dmg*" 15
remove_glob "*windows*exe*" 15
remove_glob "*windows*msi*" 30
remove_glob "*ubuntu*.deb*" 15
remove_glob "*debian7*.deb*" 30
remove_glob "*debian8*.deb*" 15
remove_glob "*debian9*.deb*" 15
remove_glob "*debian10*.deb*" 15
remove_glob "*centos6*.rpm*" 15
remove_glob "*centos8*.rpm*" 15
remove_glob "*suse*.rpm*" 15
remove_glob "*rhel8*.rpm*" 15
remove_glob "*oel*.rpm*" 15

echo @@@@@@@@@
echo Clean up cbq
echo @@@@@@@@@
cd ${LATESTBUILDS}/cbq
remove_glob cbq-linux 15
remove_glob cbq-macos 15
remove_glob cbq-windows.exe 15

echo @@@@@@@@@
echo Clean up couchbase-sync-gateway
echo @@@@@@@@@
cd ${LATESTBUILDS}/sync_gateway

# All tar.gz packages older than 30/60 days
remove_glob "couchbase-sg-accel*.tar.gz*" 60
remove_glob "couchbase-sync-gateway*.tar.gz*" 60

# older than 30/60 days
remove_glob "*.zip*" 60
remove_glob "*.rpm*" 60
remove_glob "*.exe*" 60
remove_glob "*.msi*" 60
remove_glob "*.deb*" 60

echo @@@@@@@@@
echo Clean up couchbase-lite-android
echo @@@@@@@@@
cd ${LATESTBUILDS}/couchbase-lite-android

# older than 30/60 days
remove_glob "*.jar*" 60
remove_glob "*.aar*" 60
remove_glob "*.apk*" 60
remove_glob "*.zip*" 60

echo @@@@@@@@@
echo Clean up couchbase-lite-ios
echo @@@@@@@@@
cd ${LATESTBUILDS}/couchbase-lite-ios

# older than 30/60 days
remove_glob "*.zip*" 60

echo @@@@@@@@@
echo Clean up couchbase-lite-net
echo @@@@@@@@@
cd ${LATESTBUILDS}/couchbase-lite-net

# older than 30/60 days
remove_glob "*.nupkg*" 60
remove_glob "*.zip*"   60
remove_glob "*.apk*"   60

echo @@@@@@@@@
echo Clean up couchbase-lite-log
echo @@@@@@@@@
cd ${LATESTBUILDS}/couchbase-lite-log

# older than 30/60 days
remove_glob "*.zip*" 60
remove_glob "*.rpm*" 60
remove_glob "*.deb*" 60

echo @@@@@@@@@
echo Clean up couchbase-lite-cblite
echo @@@@@@@@@
cd ${LATESTBUILDS}/couchbase-lite-cblite

# older than 30/60 days
remove_glob "*.zip*" 60

echo @@@@@@@@@
echo Clean up ALL products
echo @@@@@@@@@
cd ${LATESTBUILDS}

# All Source tarballs older than 2 days
remove_glob "*source.tar.gz" 2
