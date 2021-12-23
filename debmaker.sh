#!/bin/bash

#Volume testing template
#ls -l /tmp/build/ > /debexport/message
#ls -l /debexport > /debexport/message2

#Check if we have working directory available, create deb package folder structure, copy source files

if test -d /tmp/build/PatchManagerPlus/
then
    cd /tmp/build/PatchManagerPlus/
    mkdir -p /PatchManagerPlus_1.0-1_arm64/DEBIAN/ && mkdir -p /PatchManagerPlus_1.0-1_arm64/DEBIAN/tmp/packageinstaller/
    cp *.{bin,json} /PatchManagerPlus_1.0-1_arm64/DEBIAN/tmp/packageinstaller/
fi

#===
#Create internal scripts and configuration files for deb package
#===
if test ! -f /tmp/build/PatchManagerPlus/DEBIAN/control
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
if test ! -f /tmp/build/PatchManagerPlus/DEBIAN/preinst 
    cat <<EOF > preinst
#Preinstallation checks here
#!/bin/bash
set -e

if [[ -d /usr/local/pmpagent]] 
then 
    cd /usr/local/pmpagent
    chmod +x RemovePMPAgent.sh
    ./RemovePMPAgent.sh
elif [[ -f /etc/desktopcentralagent/dcagentsettings.json ]]
then
    AgentCustomPathData=$(</etc/desktopcentralagent/dcagentsettings.json)
    cd "$(echo $AgentCustomPathData | awk -F '"' '{print $4}')"
    chmod +x RemovePMPAgent.sh
    ./RemovePMPAgent.sh
fi
EOF
fi

if test ! -f /tmp/build/PatchManagerPlus/DEBIAN/postinst
    cat <<EOF > postinst
#Postinstallation steps here
set -e
cd /tmp/packageinstaller/
chmod +x PatchManagerPlus_LinuxAgent.bin
./PatchManagerPlus_LinuxAgent.bin
EOF
fi

if test ! -f /tmp/build/PatchManagerPlus/DEBIAN/prerm 
    cat <<EOF > 
#Prepare remove
set -e
systemctl stop dcservice
EOF
fi

if test ! -f /tmp/build/PatchManagerPlus/DEBIAN/postrm
    cat <<EOF > 
#Purge
if [[ -d /usr/local/pmpagent]] 
then 
    cd /usr/local/pmpagent
    chmod +x RemovePMPAgent.sh
    ./RemovePMPAgent.sh
elif [[ -f /etc/desktopcentralagent/dcagentsettings.json ]]
then
    AgentCustomPathData=$(</etc/desktopcentralagent/dcagentsettings.json)
    cd "$(echo $AgentCustomPathData | awk -F '"' '{print $4}')"
    chmod +x RemovePMPAgent.sh
    ./RemovePMPAgent.sh
fi
EOF
fi

#Template to bild the package
cd /debexport/
dpkg-deb --build --root-owner-group /tmp/build/PatchManagerPlus/PatchManagerPlus_1.0-1_arm64/

