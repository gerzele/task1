#!/bin/bash

#Volume testing template
#ls -l /tmp/build/ > /debexport/message
#ls -l /debexport > /debexport/message2

#Check if we have working directory available, create deb package folder structure, copy source files

#Setting variables
BIN_FOLDER="/tmp/build/PatchManagerPlus"
DEB_FOLDER="PatchManagerPlus_1.0-1_arm64/DEBIAN"
PACKAGE_FOLDER="PatchManagerPlus_1.0-1_arm64"

WORKING_DIR="/tmp/build/"
EXPORT_FOLDER="/debexport/"

cd $WORKING_DIR

if test -d $BIN_FOLDER
then
    mkdir -p $PACKAGE_FOLDER/usr/packageinstaller/ $PACKAGE_FOLDER/DEBIAN
    cp $BIN_FOLDER/*.{bin,json} $PACKAGE_FOLDER/usr/packageinstaller/
fi

#Adding mandatory packacge information
if test ! -f $DEB_FOLDER/control
then
    cp -f control $DEB_FOLDER/
fi

#Adding pre\post installation scripts
if test ! -f $DEB_FOLDER/preinst 
then
    cp -f preinst $DEB_FOLDER/
fi

if test ! -f $DEB_FOLDER/postinst
then
    cp -f postinst $DEB_FOLDER/
fi

if test ! -f $DEB_FOLDER/prerm 
then
    cp -f prerm $DEB_FOLDER/
fi

if test ! -f $DEB_FOLDER/postrm
then
    cp -f prerm $DEB_FOLDER/
fi

#Template to bild the package
cd $EXPORT_FOLDER
dpkg-deb --build --root-owner-group $WORKING_DIR/$PACKAGE_FOLDER /$EXPORT_FOLDER

