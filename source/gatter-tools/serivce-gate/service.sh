#!/usr/bin/gtkdialog -e 

TP_="/tmp/services"
TPS_="/tmp/service-gate"

:> "$TP_"

# download List services 
service --status-all > "$TP_"


LIST_SERVICES() {

:> "$TPS_"

while read A ; do 
	_ST=$(echo $A | awk '{gsub("\\[|]",""); print $1}')
	_STT=$(echo $A | awk '{gsub("\\[|]",""); print $2}')
	if [ "$_ST" = "+" ];then
		echo "gtk-yes | $_STT" >> "$TPS_"
	else
		echo "gtk-no | $_STT" >> "$TPS_"
	fi 
done < "$TP_"

}

LIST_SERVICES

#---------#
# LICENSE #
#---------#
export LICENSE_DIALOG='
<window title="License" resizable="false" icon-name="gtk-info" width-request="550" height-request="250">
<vbox>
	<edit editable="false">
		<default>
"
Service Gate is free software: you can redistribute it and/or modify
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
		<input file icon="service-gate"></input>
	</pixmap>
	<text use-markup="true" justify="2">
		<label>
"Service Gate 0.1 :
Service Manager For Gatter Linux 

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
<window title="Gatter Service Manager" icon-name="device-gate">
<vbox>
	<pixmap><width>48</width><input file icon="service-gate"></input></pixmap>
	<text use-markup="true"><label>"<span font='"'Terminus Bold 12'"'>Gatter Service Manager</span>"</label></text>
	<tree auto-refresh="true">
		<label>Services </label>
		<variable>SERVICES</variable>
		<height>200</height>
		<input file stock-column="0">'"$TPS_"'</input>
	</tree>
	<hbox homogeneous="true">
		<button width-request="100">
			<label>Stop</label>
			<input file icon="gtk-no"></input>
			<action>service $SERVICES stop</action>
			<action>LIST_SERVICES</action>
			<action>REFRESH:SERVICES</action>
		</button>
		<button width-request="100">
			<label>Restart</label>
			<input file stock="gtk-refresh"></input>
			<action>service $SERVICES restart</action>
			<action>LIST_SERVICES</action>
			<action>REFRESH:SERVICES</action>
		</button>
		<button width-request="100">
			<label>Start</label>
			<input file icon="gtk-apply"></input>
			<action>service $SERVICES start</action>
			<action>LIST_SERVICES</action>
			<action>REFRESH:SERVICES</action>
		</button>
	</hbox>
	<hbox homogeneous="true">
		<button width-request="100">
			<label>About</label>
			<input file stock="gtk-about"></input>
			<action>gtkdialog -c -p ABOUT</action>
		</button>
		<button width-request="100">
			<label>Cancel</label>
			<input file stock="gtk-cancel"></input>
		</button>
	</hbox>
</vbox>
</window>'
