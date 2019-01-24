#! /usr/bin/gtkdialog -e

#[ "$(whoami)" != "root" ] && echo ' This APP Need Root Permition, USE "sudo" or "gsu" ' && exit 1

# hddtemp, hwinfo, xinput ; inxi 

#--------------------#
# Change Dialog Font #
#--------------------#
echo 'style "specialmono"
{
  font_name="Terminus 11"
}
widget "*mono" style "specialmono"
class "GtkText*" style "specialmono"' > /tmp/gtkrc_mono

export GTK2_RC_FILES=/tmp/gtkrc_mono:$HOME/.gtkrc-2.0

#-----------#
# Info File #
#-----------#
INFO_ICON="$PWD/info_gate.png"

echo " Please Item From Menu Bar ... " > /tmp/info_gate.txt

#----------------#
# Save INFO Gate #
#----------------#
SAVE_INFO ()
{

List_dir () { ls ${1:-$HOME} | while read LINE; do echo "<item>$LINE</item>"; done }

echo '
<window title="Save Inforation" position="1" icon-name="gtk-save">
<vbox>
	<text use-markup="true">
		<label>
			"<b><span font='"'Terminus Bold 30'"'>INFO</span>__<span font='"'Terminus Bold 30'"' color='"'#4E4E4E'"'>GATE</span></b>"
		</label>
	</text>
	<text><label>Save Full Report About your Computer</label></text>
	<hbox>
	<vbox>
		<text><label>File Label :</label></text>
		<entry>
			<variable>FILE</variable>
			<default>info_gate</default>
		</entry>
	</vbox>
	<vbox>
		<text><label>Save Directory :</label></text>
		<comboboxtext case-sensitive="true" value-in-list="true">
		<variable>DIR</variable>
			'"$(List_dir)"'
		</comboboxtext>
	</vbox>
	</hbox>
	<hbox>
	<button width-request="100">
		<input file stock="gtk-save"></input>
		<label>Save</label>
		<action>lshw > $FILE.txt</action>
		<action>EXIT:exit</action>
	</button>
	<button width-request="100">
		<input file stock="gtk-cancel"></input>
		<label>Cancel</label>
	</button>
	</hbox>
</vbox>
</window>
' | gtkdialog -c -s
exit 0
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
Info Gate is free software: you can redistribute it and/or modify
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
		<input file icon="info-gate"></input>
	</pixmap>
	<text use-markup="true" justify="2">
		<label>
"Info Gate 0.2 :
Information Displayer For Gatter Linux 

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

#------------#
# Cpu Dialog #
#------------#
CPU_DIALOG='
<menu label="_Cpu" use-underline="true">
	<menuitem label="Cpu info" stock="gtk-info">
		<action>cat /proc/cpuinfo > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="LsCpu" stock="gtk-info">
		<action>lscpu > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Cpu Process" stock="gtk-info">
		<action>mpstat -A > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Kmod" stock="gtk-info">
		<action>kmod list > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="PsTree" stock="gtk-info">
		<action>pstree > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
</menu>
'

#--------#
# X Info #
#--------#
X_INFO_DIALOG='
<menu label="X Info" user-underline="true">
	<menuitem label="Xvinfo"  stock="gtk-info">
		<action>xvinfo > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Xsetpointer"  stock="gtk-info">
		<action>xsetpointer -l > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Xset"  stock="gtk-info">
		<action>xset -q > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Xmodmap"  stock="gtk-info">
		<action>xmodmap > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Xlsfonts"  stock="gtk-info">
		<action>xlsfonts > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Xlsclients"  stock="gtk-info">
		<action>xlsclients > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Xlsatoms"  stock="gtk-info">
		<action>xlsatoms > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Xinput"  stock="gtk-info">
		<action>xinput > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Xdpyinfo"  stock="gtk-info">
		<action>xdpyinfo > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
</menu>'

#------#
# INXI #
#------#
INXI_DIALOG='
<menu label="_Inxi" use-underline="true">
	<menuitem label="Cpu" stock="gtk-info">
		<action>inxi -C -c 0 > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Graphics" stock="gtk-info">
		<action>inxi -G -c 0 > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Audio" stock="gtk-info">
		<action>inxi -A -c 0 > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Hard Drive" stock="gtk-info">
		<action>(inxi -D -c 0 && inxi -p -c 0) > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Sensors" stock="gtk-info">
		<action>inxi -s -c 0 > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="NIC & IP address" stock="gtk-info">
		<action>inxi -i -c 0 > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="System & Processes" stock="gtk-info">
		<action>(inxi -S -c 0 && inxi -I -c 0 && inxi -c 0 -t c10) > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="All" stock="gtk-info">
		<action>inxi -F -c 0 > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
</menu>
'

#------------#
# Hdd Dialog #
#------------#
HDD_DIALOG='
<menu label="_HHD" use-underline="true">
	<menuitem label="Fdisk" stock="gtk-info">
		<action>sudo fdisk -l > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="DF" stock="gtk-info">
		<action>(df && echo "---------------" && df -H && echo "-------------" && df -HT) > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Mount" stock="gtk-info">
		<action>mount > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="HDD Temp" stock="gtk-info">
		<action>sudo hddtemp /dev/sd* > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="HDparm" stock="gtk-info">
		<action>(sudo hdparm /dev/sd*) > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Disk stats" stock="gtk-info">
		<action>cat /proc/diskstats > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
</menu>
'

#------------#
# Gpu Dialog #
#------------#
GPU_DIALOG='
<menu label="_Gpu" use-underline="true">
	<menuitem label="LSPCI" stock="gtk-info">
		<action>(lspci | grep -i vga && lspci -vvnn | grep VGA) > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Lshw" stock="gtk-info">
		<action>(lshw -class display) > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
</menu>
'

#------------#
# Log Dialog #
#------------#
LOG_DIALOG='
<menu label="_Logs" use-underline="true">
	<menuitem label="APT History" stock="gtk-info">
		<action>cat /var/log/apt/history.log > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Update" stock="gtk-info">
		<action>cat /var/log/last-update-log.log > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Alternatives" stock="gtk-info">
		<action>cat /var/log/alternatives.log > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Kernal Log" stock="gtk-info">
		<action>dmesg > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Who" stock="gtk-info">
		<action>w > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Last" stock="gtk-info">
		<action>last > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
</menu>
'

#----------------#
# Devices Dialog #
#----------------#
DEVICES_DIALOG='
<menu label="_Devices" use-underline="true">
	<menuitem label="LsUsb" stock="gtk-info">
		<action>lsusb -t > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="hwinfo" stock="gtk-info">
		<action>hwinfo --short > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menu label="Mem" stock="gtk-info">
		<menuitem label="free">
			<action>free -h > /tmp/info_gate.txt</action>
			<action>refresh:INFO</action>
		</menuitem>
		<menuitem label="MEM info">
			<action>cat /proc/meminfo > /tmp/info_gate.txt</action>
			<action>refresh:INFO</action>
		</menuitem>
		<menuitem label="vmstat">
			<action>vmstat > /tmp/info_gate.txt</action>
			<action>refresh:INFO</action>
		</menuitem>
	</menu>
	<menuitem label="battery" stock="gtk-info">
		<action>upower -d > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Biosdecode" stock="gtk-info">
		<action>sudo biosdecode > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
</menu>
'

#----------------#
# Network Dialog #
#----------------#
NETWORK_DIALOG='
<menu label="_Network" use-underline="true">
	<menuitem label="ifconfig" stock="gtk-info">
		<action>ifconfig -a > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="IPCS" stock="gtk-info">
		<action>ipcs -a > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="IPmaddr" stock="gtk-info">
		<action>ipmaddr show all > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="NetStat" stock="gtk-info">
		<action>netstat > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="NetWorkCtl" stock="gtk-info">
		<action>networkctl -a > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="HOSTS" stock="gtk-info">
		<action>(cat /etc/hosts) > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Ss" stock="gtk-info">
		<action>ss > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
</menu>
'

#---------------#
# System Dialog #
#---------------#
SYSTEM_DIALOG='
<menu label="_System" use-underline="true">
	<menuitem label="Sysctl" stock="gtk-info">
		<action>sysctl -a > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Export" stock="gtk-info">
		<action>export > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="PATH" stock="gtk-info">
		<action>(echo "$PATH" | tr ":" "\n") > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="SHELLS" stock="gtk-info">
		<action>(cat /etc/shells && echo "-------\nShell in use is : $SHELL") > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="LOCAL" stock="gtk-info">
		<action>locale > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Term Info" stock="gtk-info">
		<action>infocmp > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Uname" stock="gtk-info">
		<action>(uname -a && echo "----------" && lsb_release -a) > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="IQR" stock="gtk-info">
		<action>cat /proc/interrupts > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="UPTIME" stock="gtk-info">
		<action>(echo "UPTIME : $(uptime -p)" && echo "UPTIME Sence : $(uptime -s) ") > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Computer ID" stock="gtk-info">
		<action>sudo dmidecode > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
	<menuitem label="Locale Endocing" stock="gtk-info">
		<action>luit -list > /tmp/info_gate.txt</action>
		<action>refresh:INFO</action>
	</menuitem>
</menu>
'

#-------------#
# Main Dialog #
#-------------#
export MAIN_DIALOG='
<window title="INFO GATE" window-position="1" icon-name="info-gate">
<vbox>
	<menubar>
		<menu label="_File" use-underline="true">
			<menuitem label="Save Full Report" stock="gtk-save">
				<action>SAVE_INFO &</action>
			</menuitem>
			<menuitem label="Quit" stock="gtk-quit">
				<action>EXIT:quit</action>
			</menuitem>
		</menu>
		
		'"$CPU_DIALOG"'
		'"$HDD_DIALOG"'
		'"$GPU_DIALOG"'
		'"$LOG_DIALOG"'
		'"$DEVICES_DIALOG"'
		'"$NETWORK_DIALOG"'
		'"$SYSTEM_DIALOG"'
		'"$X_INFO_DIALOG"'
		'"$INXI_DIALOG"'
		
		<menu label="_Help" use-underline="true">
			<menuitem label="About" stock="gtk-about">
				<action>gtkdialog -c --program=ABOUT &</action>
			</menuitem>
		</menu>
	</menubar>
    <pixmap>
        <input file>'"/usr/share/pixmaps/info-logo.png"'</input>
    </pixmap>
	<frame Gatter Information>
		<edit name="mono" editable="false" cursor-visible="false">
			<variable>INFO</variable>
			<input file>/tmp/info_gate.txt</input>
			<height>400</height>
			<width>600</width>
		</edit>
	</frame>
	<hbox>
	<button width-request="100">
		<input file stock="gtk-cancel"></input>
		<label>Cancel</label>
	</button>
	</hbox>
</vbox>
</window>
'
