#! /usr/bin/gtkdialog -e

export MIME_FILE="/usr/share/applications/mimeinfo.cache"

#---------#
# LICENSE #
#---------#
export LICENSE_DIALOG='
<window title="License" resizable="false" icon-name="gtk-info" width-request="550" height-request="250">
<vbox>
	<edit editable="false">
		<default>
"
Mime Gate is free software: you can redistribute it and/or modify
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
		<input file icon="mime-gate"></input>
	</pixmap>
	<text use-markup="true" justify="2">
		<label>
"Mime Gate 0.1 :
Mime File Editor tool For Gatter Linux 

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

_SET_MIME_() {
	grep "$MIMES" "$MIME_FILE" | sed -i "s/$_/$MIMES=$MIME_ENTRY;/" "$MIME_FILE"
}

#----------#
# SET MIME #
#----------#
SET_MIME ()
{
	gsu "sed -i "d,$(grep $MIMES $MIME_FILE)," $MIME_FILE"
	sudo echo "$MIMES=$MIME_ENTRY" >> $MIME_FILE
}

#-----------#
# EDIT MINE #
#-----------#
EDIT_MIME ()
{
	gsu "geany -i $MIME_FILE"
}

#-------------#
# MAIN DIALOG #
#-------------#
export MAIN_DIALOG='
<window title=" Mime Gate Editor" window_position="1" icon-name="menu-editor">
<vbox>
	<text use-markup="true" justify="2"><label>"<span font='"'Terminus 14'"'><b><u> Edit Mime Applications </u></b></span>"</label></text>
	<hbox homogeneous="true">
		<button width-request="120"><label>Edit Manual</label><input file stock="gtk-edit"></input><action>EDIT_MIME</action></button>
		<button width-request="100"><label>About</label><input file stock="gtk-about"></input><action>gtkdialog -c --program=ABOUT</action></button>
	</hbox>
	<tree rules_hint="true" headers-clickable="false" auto-refresh="true">
		<label>Choose an Mimeapp de Edit</label>
		<height>300</height>
		<width>500</width>
		<variable>MIMES</variable>
		<input>grep "=" "$MIME_FILE" | cut -d "=" -f1</input>
		<action>grep "$MIMES" "$MIME_FILE" | cut -d "=" -f2- | tr -d ";" > /tmp/mime</action>
	</tree>
	<hbox>
		<text use-markup="true" justify="2">
		<label>
			"<span font='"'Terminus 11'"'>Edit Application : </span>"
		</label>
		</text>
		<entry auto-refresh="true" fs-title="Mime Select" fs-folder="/usr/share/applications">
			<input file>/tmp/mime</input>
			<variable>MIME_ENTRY</variable>
		</entry>
		<button>
			<input file stock="gtk-open"></input>
			<action function="fileselect">MIME_ENTRY</action>
			<action>echo "$(basename $MIME_ENTRY)" > /tmp/mime</action>
		</button>
	</hbox>
	<hbox homogeneous="true">
		<button width-request="100"><label>Set Mime</label><input file stock="gtk-execute"></input><action>SET_MIME &</action></button>
		<button width-request="100"><label>Cancel</label><input file stock="gtk-cancel"></input></button>
	</hbox>
</vbox>
</window>'
