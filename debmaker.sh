#!/bin/bash

#Volume testing template
#ls -l /tmp/build/ > /debexport/message
#ls -l /debexport > /debexport/message2

#Check if we have working directory available, create deb package folder structure, copy source files
if [[ -d $BasePath=/tmp/build/PatchManagerPlus/ ]]
then
    cd $BasePath
    mkdir -p /PatchManagerPlus_1.0-1_arm64/DEBIAN/ && mkdir -p /PatchManagerPlus_1.0-1_arm64/tmp/packageinstaller/
    cp *.{bin,json} /PatchManagerPlus_1.0-1_arm64/tmp/packageinstaller/
    cd $DebPackagePath=/tmp/build/PatchManagerPlus/DEBIAN/
fi

#===
#Create internal scripts and configuration files for deb package
#===
if [[ -f $DebPackagePath/control ]]
then
    cat <<EOF > control
        Package: PatchManagerPlus
        Version: 1.0 
        Section: base 
        Priority: optional 
        Architecture: amd64 
        Maintainer: vendor@vendordomain.com
        Description: Package Manager
EOF
fi

#Adding pre\post installation scripts
if [[ -f $DebPackagePath/preinst ]]
    cat <<EOF > 
#Preinstallation checks here
#!/bin/bash
set -e

if systemctl is-active --quiet dcservice
then
    systemctl stop dcservice
else   
    echo 'Nothing to stop'
fi
EOF
fi

if [[ -f $DebPackagePath/postinst ]]
    cat <<EOF > 
#Postinstallation steps here
set -e
chmod +x PatchManagerPlus_LinuxAgent.bin
EOF
fi


#Template to bild the package
#dpkg-deb --build --root-owner-group $BasePath/PatchManagerPlus_1.0-1_arm64

