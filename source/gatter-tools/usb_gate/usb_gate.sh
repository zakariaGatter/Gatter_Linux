#! /usr/bin/gtkdialog -e

[ "$(whoami)" != "root" ] && echo ' This APP Need Root Permition, USE "sudo" or "gsu" ' && exit 1

#---------#
# LICENSE #
#---------#
export LICENSE_DIALOG='
<window title="License" resizable="false" icon-name="gtk-info" width-request="550" height-request="250">
<vbox>
	<edit editable="false" cursor-visible="false">
		<default>
"
Usb Gate is free software: you can redistribute it and/or modify
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
	<edit editable="false" cursor-visible="false">
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
		<input file icon="usb_gate"></input>
	</pixmap>
	<text use-markup="true" justify="2">
		<label>
"USB Gate 0.1 :
USB Tool For Gatter Linux 

Copyright (c) 2017" 
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

#-------------#
# Format Type #
#-------------#
TYPE_ITEMS="
<item>FAT-32</item>
<item>NTFS</item>
<item>EXT2</item>
<item>EXT3</item>
<item>EXT4</item>"

#---------------------#
# Get All USB Connect #
#---------------------#
USB_ITEMS () 
{
USB_LIST=$(lsblk -n -l -o NAME,TRAN | awk '/usb/{print $1}')

for usb in $USB_LIST ; do 
USB_NAME=$(lsblk -n -l -o VENDOR /dev/$usb)
USB_SIZE=$(lsblk -n -l -o SIZE,TYPE /dev/$usb | awk '/disk/{print $1}')

	echo "<item>$USB_NAME [/dev/$usb] ($USB_SIZE)</item>"
	
done 
}

#---------------#
# Seccus Dialog #
#---------------#
SECCUS_DIALOG ()
{
echo '
<window title="USB GATE SECCUS" window-position="1" resizable="false" widt-request="300" icon-name="gtk-ok">
<vbox>
	<pixmap>
		<height>48</height>
		<width>48</width>
		<input file icon="usb-creator"></input>
	</pixmap>
	<frame>
		<text use-markup="true" justify="2">
			<label>
				" '$1' "
			</label>
		</text>
	</frame>
	<hbox homogeneous="true">
	<button cancel></button>
	</hbox>
</vbox>
</window>
' | gtkdialog -c -s

exit 0
}

#--------------#
# Error Dialog #
#--------------#
ERROR_DIALOG ()
{
echo '
<window title="USB GATE ERROR" window-position="1"  icon-name="messagebox_warning" resizable="false" widt-request="300">
<vbox>
	<pixmap>
		<width>48</width>
		<height>48</height>
		<input file stock="gtk-dialog-warning"></input>
	</pixmap>
	<frame>
		<text use-markup="true" justify="2">
			<label>
				" '$1' "
			</label>
		</text>
	</frame>
	<hbox homogeneous="true">
	<button cancel></button>
	</hbox>
</vbox>
</window>
' | gtkdialog -c -s 

exit 1
}

#-------------#
# WAIT DIALOG #
#-------------#
WAIT_DIALOG ()
{
yad --title="USB GATE" \
	--text="$1" \
	--width=400 \
	--window-icon="usb-creator" \
	--image="usb-creator" \
	--image-on-top \
	--center \
	--progress \
	--pulsate \
	--auto-close 
}

#------------#
# Format USB #
#------------#
FORMAT_USB ()
{
	
	[ -z "$DEVICE" ] && ERROR_DIALOG " NO USB Stick Set. Please pick the Device you want to format and Try again  "
	[ -z "$USB_LABEL" ] && ERROR_DIALOG " No LABEL Set. Please Type the Device Label and Try again "
	
	USB_PATH=$(echo "$DEVICE" | awk '{print $2}' | tr -d "[-]")
	
	case "$TYPE" in 
		"FAT-32" )
			# Unmount Partition before start Format
			[ "$(mount | grep -c "$USB_PATH")" -gt "0" ] && sudo umount "$USB_PATH"[1-9]
			# delete existing partition then create new linux partition
			echo -e "d\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\no\nn\np\n1\n\n\nt\nb\nw" | sudo fdisk "$USB_PATH"
			
			sudo mkfs.fat -F 32 -n "$USB_LABEL" -I "$USB_PATH"1 | WAIT_DIALOG "<b> $DEVICE </b>\n is Formating. Please Wait ... "
			[ "$?" != "0" ] && ERROR_DIALOG "<b>$USB_PATH</b> There is unknow ERROR "
			
				# set permission
				mkdir -p /tmp/testmount
				sudo mount "$USB_PATH" /tmp/testmount
				sudo chmod -R 777 /tmp/testmount
				sudo umount /tmp/testmount
				rmdir /tmp/testmount
				
			SECCUS_DIALOG "<b>$USB_PATH</b> Format Seccusfuly "
		;;
		"NTFS" )
			# Unmount Partition before start Format
			[ "$(mount | grep -c "$USB_PATH")" -gt "0" ] &&sudo umount "$USB_PATH"1
			# delete existing partition then create new linux partition
			echo -e "d\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\no\nn\np\n1\n\n\nt\n7\nw" | sudo fdisk "$USB_PATH"
			
			sudo mkfs.ntfs -f -L "$USB_LABEL" "$USB_PATH"1 | WAIT_DIALOG "<b> $DEVICE </b>\n is Formating. Please Wait ... "
			[ "$?" != "0" ] && ERROR_DIALOG "<b>$USB_PATH</b> There is unknow ERROR "
			
				# set permission
				mkdir -p /tmp/testmount
				sudo mount "$USB_PATH"1 /tmp/testmount
				sudo chmod -R 777 /tmp/testmount
				sudo umount /tmp/testmount
				rmdir /tmp/testmount
				
			SECCUS_DIALOG "<b>$USB_PATH</b> Format Seccusfuly " 
		;;
		"EXT2" )
			# Unmount Partition before start Format
			[ "$(mount | grep -c "$USB_PATH")" -gt "0" ] &&sudo umount "$USB_PATH"1
			# delete existing partition then create new linux partition
			echo -e "d\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\no\nn\np\n1\n\n\nw" | sudo fdisk "$USB_PATH"
			echo -e "y\n" | sudo mkfs.ext2 -L "$USB_LABEL" "$USB_PATH"1 | WAIT_DIALOG "<b> $DEVICE </b>\n is Formating. Please Wait ... "
			[ "$?" != "0" ] && ERROR_DIALOG "<b>$USB_PATH</b> There is unknow ERROR "
			
				# set permission
				mkdir -p /tmp/testmount
				sudo mount "$USB_PATH"1 /tmp/testmount
				sudo chmod -R 777 /tmp/testmount
				sudo umount /tmp/testmount
				rmdir /tmp/testmount
				
			SECCUS_DIALOG "<b>$USB_PATH</b> Format Seccusfuly "
		;;
		"EXT3" )
			# Unmount Partition before start Format
			[ "$(mount | grep -c "$USB_PATH")" -gt "0" ] &&sudo umount "$USB_PATH"1
			# delete existing partition then create new linux partition
			echo -e "d\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\no\nn\np\n1\n\n\nw" | sudo fdisk "$USB_PATH"
			echo -e "y\n" | sudo mkfs.ext3 -L "$USB_LABEL" "$USB_PATH"1 | WAIT_DIALOG "<b> $DEVICE </b>\n is Formating. Please Wait ... "
			[ "$?" != "0" ] && ERROR_DIALOG "<b>$USB_PATH</b> There is unknow ERROR "
			
				# set permission
				mkdir -p /tmp/testmount
				sudo mount "$USB_PATH"1 /tmp/testmount
				sudo chmod -R 777 /tmp/testmount
				sudo umount /tmp/testmount
				rmdir /tmp/testmount
				
			SECCUS_DIALOG "<b>$USB_PATH</b> Format Seccusfuly "
		;;
		"EXT4" )
			# Unmount Partition before start Format
			[ "$(mount | grep -c "$USB_PATH")" -gt "0" ] &&sudo umount "$USB_PATH"1
			# delete existing partition then create new linux partition
			echo -e "d\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\nd\n\no\nn\np\n1\n\n\nw" | sudo fdisk "$USB_PATH"
			echo -e "y\n" | sudo mkfs.ext4 -L "$USB_LABEL" "$USB_PATH"1 | WAIT_DIALOG "<b> $DEVICE </b>\n is Formating. Please Wait ... "
			[ "$?" != "0" ] && ERROR_DIALOG "<b>$USB_PATH</b> There is unknow ERROR "
			
				# set permission
				mkdir -p /tmp/testmount
				sudo mount "$USB_PATH"1 /tmp/testmount
				sudo chmod -R 777 /tmp/testmount
				sudo umount /tmp/testmount
				rmdir /tmp/testmount
				
			SECCUS_DIALOG "<b>$USB_PATH</b> Format Seccusfuly "
		;;
	esac
	
}

#-----------#
# Write ISO #
#-----------#
ISO_USB () 
{
	[ -z "$DEVICE" ] && ERROR_DIALOG "<b>NO USB Stick</b> Set. Please pick the Device you want to format and Try again  "
	[ -z "$FILE" ] && ERROR_DIALOG "<b>NO ISO FILE</b> Set. Please pick the ISO you want to Write and Try again  "
	
	USB_PATH=$(echo "$DEVICE" | awk '{print $2}' | tr -d "[-]")
	
	case "$FILE" in 
		*.iso )
			[ "$(mount | grep -c "$USB_PATH")" -gt "0" ] && sudo umount "$USB_PATH"1
			(sudo dd bs=4M if="$FILE" of="$USB_PATH" status=progress && sync) | WAIT_DIALOG "<b> $FILE </b>\n is Writing this may take domr time . Please Wait ... "
			[ "$?" = "0" ] && SECCUS_DIALOG "<b>$USB_PATH</b> Write Seccusfuly " || ERROR_DIALOG "<b>$USB_PATH</b> There is unknow ERROR "
		;;
		*.img )
			[ "$(mount | grep -c "$USB_PATH")" -gt "0" ] && sudo umount "$USB_PATH"1
			(sudo dd bs=4M if="$FILE" of="$USB_PATH" status=progress && sync) | WAIT_DIALOG "<b> $FILE </b>\n is Writing this may take domr time . Please Wait ... "
			[ "$?" = "0" ] && SECCUS_DIALOG "<b>$USB_PATH</b> Write Seccusfuly " || ERROR_DIALOG "<b>$USB_PATH</b> There is unknow ERROR "
		;;
		* )
			ERROR_DIALOG "<b> $ISO_FILE </b> : Is not Valide ISO to Write "
		;;
	esac 
}

#---------------#
# Format Dialog #
#---------------#
export GATTER_FORMAT='
<frame>
	<comboboxtext>
		<variable>DEVICE</variable>
		'"$(USB_ITEMS)"'
	</comboboxtext>
	<hbox homogeneous="true">
	<vbox>
	<text>
		<label> Format Type :</label>
	</text>
	<comboboxtext width-request="150">
		<variable>TYPE</variable>
		'"$TYPE_ITEMS"'
	</comboboxtext>
	</vbox>
	<vbox>
	<text><label> USB Label :</label></text>
	<entry width-request="150">
		<variable>USB_LABEL</variable>
		<default>USB_GATE</default>
	</entry>
	</vbox>
	</hbox>
<hbox homogeneous="true">
	<button width-request="100">
		<input file stock="gtk-apply"></input>
		<label>Apply</label>
		<action>FORMAT_USB &</action>
	</button>
</hbox>
</frame>
'

#------------#
# ISO Dialog #
#------------#
export GATTER_ISO='
<frame>
	<comboboxtext>
		<variable>DEVICE</variable>
		'"$(USB_ITEMS)"'
	</comboboxtext>
	<text><label> ISO File :</label></text>
	<hbox>
		<entry>
			<variable>FILE</variable>
		</entry>
		<button>
			<input file stock="gtk-open"></input>
			<action type="fileselect">FILE</action>
		</button>
	</hbox>
<hbox homogeneous="true">
	<button width-request="100">
		<input file stock="gtk-apply"></input>
		<label>Apply</label>
		<action>ISO_USB &</action>
	</button>
</hbox>
</frame>
'

#-------------#
# Main Dialog #
#-------------#
export MAIN_DIALOG='
<window title="USB GATE" window-position="1" resizable="false" width-request="400" icon-name="usb-creator">
<vbox>
	<text use-markup="true">
		<label>
			"<b><span font='"'Terminus Bold 20'"'>USB</span>  <span font='"'Terminus Bold 20'"' color='"'#4E4E4E'"'>Gate</span></b>"
		</label>
	</text>
<notebook labels="USB Format|ISO writer">
	'"$GATTER_FORMAT"'
	'"$GATTER_ISO"'
</notebook>
<hbox homogeneous="true">
	<button width-request="100"><label>About</label><input file stock="gtk-about"></input><action>gtkdialog -c --program=ABOUT</action></button>
	<button width-request="100"><input file stock="gtk-cancel"></input><label>Cancel</label></button>
</hbox>
</vbox>
</window>
'
