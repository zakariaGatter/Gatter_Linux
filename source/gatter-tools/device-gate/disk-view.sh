#!/usr/bin/gtkdialog -e

LIST_DEVICES() {
for M in $(lsblk -n -l | grep -v "/$" | awk '/part/{print $1}') ; do 
    [ -z "$(grep "/dev/$M" /proc/mounts)" ] && {
        MOUNT_POINT="/dev/$M"
        INFO_DEV=$(lsblk $MOUNT_POINT -l -n -o "SIZE" )
        LABEL_DEV=$(lsblk $MOUNT_POINT -l -n -o "LABEL" )

        #echo "<item icon=\"block-device\"> ${MOUNT_POINT} | $LABEL_DEV |  ${INFO_DEV} | --- </item>"
        echo "${MOUNT_POINT} | $LABEL_DEV |  ${INFO_DEV} | --- " >> /tmp/disk-gate 
    } || {
        UNMOUNT_POINT="/dev/$M"
        INFO_DEV=$(lsblk $UNMOUNT_POINT -o "SIZE" -l -n )
        LABEL_DEV=$(lsblk $UNMOUNT_POINT -l -n -o "LABEL" )

        #echo "<item icon=\"block-device\"> $UNMOUNT_POINT | $LABEL_DEV | $INFO_DEV | Mounted </item>"
        echo "$UNMOUNT_POINT | $LABEL_DEV | $INFO_DEV | Mounted " >> /tmp/disk-gate 
    }
done > /tmp/disk-gate
}

LIST_DEVICES

MSG_DIALOG() {
echo '
<window title="Message Box" icon-name="'"${1}"'">
<vbox>
<pixmap><width>48</width><input file stock="'"${1}"'"></input></pixmap>
<text use-markup="true"><label>"<span font='"'Terminus Bold 12'"'>Diff Gate</span>"</label></text>
<frame>
<text use-markup="true"><label>"<span font='"'Terminus 12'"'>'"${2}"'</span>"</label></text>
</frame>
<hbox><button cancel></button></hbox>
</vbox>
</window>' | gtkdialog -s
}

_MOUNT_() {
if [ -n "$(grep "$DISK" /proc/mounts)" ];then 
	MSG_DIALOG "gtk-no" "This Device Is Already Mounted"
else
	udisksctl mount -b $DISK
	notify-send "Gatter Disk Viewser" "$DSIK is been Mounted" -i "gnome-dev-harddisk-usb"
fi
}

_UNMOUNT_() {
if [ -z "$(grep "$DISK" /proc/mounts)" ];then 
	MSG_DIALOG "gtk-no" "This Device Is Already UNmounted"
else
	udisksctl unmount -b $DISK
	notify-send "Gatter Disk Viewser" "$DSIK is been UNmounted" -i "gnome-dev-removable"
fi
}

#---------#
# LICENSE #
#---------#
export LICENSE_DIALOG='
<window title="License" resizable="false" icon-name="gtk-info" width-request="550" height-request="250">
<vbox>
	<edit editable="false">
		<default>
"
Device Gate is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with .  If not, see <http://www.gnu.org/licenses/>.
"
		</default>
	</edit>
</vbox>
</window>
'

#---------#
# CREDITS #
#---------#
export CREDITS_DIALOG='
<window title="Credits" resizable="false" icon-name="gtk-info" width-request="350">
<vbox>
	<edit editable="false">
		<default>
"
Zakaria Barkouk <zakaria.gatter@gmail.com>
"
		</default>
	</edit>
</vbox>
</window>
'

#-------#
# ABOUT #
#-------#
export ABOUT='
<window title="About" icon-name="gtk-about" resizable="false">
<vbox>
	<pixmap>
		<width>64</width>
		<height>64</height>
		<input file icon="device-gate"></input>
	</pixmap>
	<text use-markup="true" justify="2">
		<label>
"Device Gate 0.1 :
Device Manager For Gatter Linux 

Copyright (c) 2019" 
		</label>
	</text>
	<hbox homogeneous="true">
		<button width-request="100">
			<label> License </label>
			<action>gtkdialog -c --program=LICENSE_DIALOG</action>
		</button>
		<button width-request="100">
			<label> Credits </label>
			<action>gtkdialog -c --program=CREDITS_DIALOG</action>
		</button>
		<button width-request="100">
			<label> Cancel </label>
			<action>EXIT:Cancel</action>
		</button>
	</hbox>
</vbox>
</window>
'
export MAIN_DIALOG='
<window title="Gatter Device Viewer" icon-name="device-gate">
<vbox>
	<pixmap><width>48</width><input file icon="device-gate"></input></pixmap>
	<text use-markup="true"><label>"<span font='"'Terminus Bold 12'"'>Gatter Device Viewer</span>"</label></text>
	<tree auto-refresh="true">
		<label>Device                        | Label | Size | Status </label>
		<input file>/tmp/disk-gate</input>
		<variable>DISK</variable>
		<height>200</height><width>600</width>
	</tree>
	<hbox homogeneous="true">
		<button width-request="100">
			<label>About</label>
			<input file stock="gtk-about"></input>
			<action>gtkdialog -c -p ABOUT</action>
		</button>
		<button width-request="100">
			<label>Mount</label>
			<input file icon="gnome-dev-harddisk-usb"></input>
			<action>_MOUNT_</action>
		</button>
		<button width-request="100">
			<label>Refresh</label>
			<input file stock="gtk-refresh"></input>
			<action>LIST_DEVICES</action>
			<action>REFRESH:DSIK</action>
		</button>
		<button width-request="100">
			<label>Unmount</label>
			<input file icon="gnome-dev-removable"></input>
			<action>_UNMOUNT_</action>
		</button>
		<button width-request="100">
			<label>Cancel</label>
			<input file stock="gtk-cancel"></input>
		</button>
	</hbox>
</vbox>
</window>'

