#!/bin/bash

CONF_DIR="$HOME/.config/auto-gate"
FUNC="${0%/*}/func"

#---------#
# LICENSE #
#---------#
export LICENSE_DIALOG='
<window title="License" resizable="false" icon-name="gtk-info" width-request="550" height-request="250">
<vbox>
	<edit editable="false">
		<default>
"
Auto Gate is free software: you can redistribute it and/or modify
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
<window title="Credits" resizable="false" icon-name="gtk-info" width-request="400">
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
<window title="About" resizable="false" icon-name="gtk-about">
<vbox>
	<pixmap>
		<width>64</width>
		<height>64</height>
		<input file icon="auto-gate"></input>
	</pixmap>
	<text use-markup="true" justify="2">
		<label>
"Auto Gate 0.1 :
Autostart manager For Gatter Linux

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
# MAIN DIALOG #
#-------------#
export MAIN_DIALOG='
<window title="Autostart gate" icon-name="session-properties" resizable="false">
<vbox>
	<text use-markup="true" justify="2">
		<label>"<span font='"'Terminus 14'"'><b><u>Add; Remove and Edit Startup Command for Openbox</u></b></span>"</label>
	</text>
	<tree rules_hint="true" headers-clickable="false" auto-refresh="true">
		<label>Choose an existing Application</label>
		<height>350</height>
		<width>400</width>
		<variable>AUTO_ITEMS</variable>
		<input>ls '"$CONF_DIR"'</input>
	</tree>
	<hbox homogeneous="true">
		<button width-request="100">
			<label>Add</label>
			<input file stock="gtk-add"></input>
			<action>'"$FUNC"' add</action>
			<action>refresh:AUTO_ITEMS</action>
		</button>
		<button width-request="100">
			<label>Edit</label>
			<input file stock="gtk-edit"></input>
			<action>'"$FUNC"' edit "$AUTO_ITEMS"</action>
			<action>refresh:AUTO_ITEMS</action>
		</button>
		<button width-request="100">
			<label>Remove</label>
			<input file stock="gtk-remove"></input>
			<action>'"$FUNC"' del "$AUTO_ITEMS"</action>
			<action>refresh:AUTO_ITEMS</action>
		</button>
	</hbox>
	<hbox homogeneous="true">
		<button width-request="100"><label>About</label><input file stock="gtk-about"></input><action>gtkdialog -c --program=ABOUT</action></button>
		<button width-request="100"><label>Cancel</label><input file stock="gtk-cancel"></input></button>
	</hbox>
</vbox>
</window>'


#------------------#
# SCRIPTS ARGUMENT #
#------------------#
if [ "$1" = "-d" ];then
	"$FUNC" exec
elif [ "$1" = "-h" -o "$1" = "--help" ];then
	echo -e "auto-gate : \n\t-d : Run Saved Application in background"
else
	gtkdialog -c -p MAIN_DIALOG
fi
