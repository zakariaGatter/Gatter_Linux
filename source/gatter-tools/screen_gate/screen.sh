#! /usr/bin/gtkdialog -e

#---------#
# LICENSE #
#---------#
export LICENSE_DIALOG='
<window title="License" resizable="false" icon-name="gtk-info" width-request="550" height-request="250">
<vbox>
	<edit editable="false">
		<default>
"
Screen Gate is free software: you can redistribute it and/or modify
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
		<input file icon="screen_gate"></input>
	</pixmap>
	<text use-markup="true" justify="2">
		<label>
"Screen Gate 0.1 :
Screenshot Manager  For Gatter Linux 

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
# SAVE DIALOG #
#-------------#
export SAVE='
<window title="Screen Gate SAVE" icon-name="gnome-screenshot" widnow_position="1" resizable="false">
<vbox>
	<pixmap>
		<width>512</width>
		<height>512</height>
		<input file>/tmp/screen.png</input>
	</pixmap>
	<frame>
		<hbox homogeneous="true">
			<vbox>
				<text><label>Screenshot Name :</label></text>
				<entry>
					<default>'"$(echo "Screen-$(date +%H-%M).png")"'</default>
					<variable>SAVE_NAME</variable>
				</entry>
			</vbox>
			<vbox>
				<text><label>Screenshot Directory :</label></text>
				<comboboxtext>
					<variable>SAV_DIR</variable>
					'"$(ls $HOME | while read DIR; do [ -d "$HOME/$DIR" ] && echo "<item>$DIR</item>"; done)"'
				</comboboxtext>
			</vbox>
		</hbox>
	</frame>
	<hbox homogeneous="true">
		<button width-request="100"><label>SAVE</label><input file stock="gtk-save"></input><action>cp -f /tmp/screen.png $HOME/$SAV_DIR/$SAVE_NAME &</action><action>EXIT:exit</action></button>
		<button width-request="100"><label>REMOVE</label><input file stock="gtk-remove"></input><action>rm -f /tmp/screen.png &</action><action>EXIT:exit</action></button>
	</hbox>
</vbox>
</window>'

#---------------------#
# SCREEN SHOT COMMAND #
#---------------------#
SCREEN () {
	[ "$WINDOW" = "true" ] && WINDOW_CMD="-u -d $DELAY"
	[ "$FULL" = "true" ] && FULL_CMD=""
	[ "$AREA" = "true" ] && AREA_CMD="-s"
	[ "$BORDER" = "true" ] && BORDER_CMD="-b"
	[ "$QUALITY" != "75" ] && QUALITY_CMD="-q $QUALITY"
	[ "$S_DELAY" = "true" ] && _DELAY="$DELAY"
	
xdotool windowminimize $(xdotool getactivewindow)

sleep 1

bash -c "scrot -d $_DELAY $WINDOW_CMD $FULL_CMD $AREA_CMD $BORDER_CMD $QUALITY_CMD /tmp/screen.png"

gtkdialog -c --program=SAVE

xdotool windowactivate $(xdotool search --name "Screen Gate")

}

#-------------#
# MAIN DIALOG #
#-------------#
export MAIN_DIALOG='
<window title="Screen Gate" icon-name="gnome-screenshot" resizable="false">
<vbox>
	<frame>
	<hbox>
		<button tooltip-text="Take Screenshot">
			<width>80</width>
			<height>80</height>
			<input file icon="screen_gate"></input>
			<action>SCREEN &</action>
		</button>
		<vseparator></vseparator>
		<vbox>
			<radiobutton tooltip-text="Get the full screen">
				<label>Grab the full screen</label>
				<default>false</default>
				<variable>FULL</variable>
			</radiobutton>
			<radiobutton tooltip-text="Use the currently focused window.">
				<label>Grab the Focus Window</label>
				<default>true</default>
				<variable>WINDOW</variable>
				<action>if false disable:BORDER</action>
				<action>if true enable:BORDER</action>
			</radiobutton>
			<radiobutton tooltip-text=" Interactively select a window or rectangle with the mouse.">
				<label>Grab the Focus Area</label>
				<default>false</default>
				<variable>AREA</variable>
			</radiobutton>
		</vbox>
		<vbox>
			<text><label>
			"        "
			</label></text>
		</vbox>
	</hbox>
	<hseparator height-request="5"></hseparator>
	    <vbox>
		<hbox homogeneous="true">
		<checkbox>
			<label>Screenshot Delay :</label>
			<variable>S_DELAY</variable>
			<action>if false disable:DELAY</action>
			<action>if true enable:DELAY</action>
		</checkbox>
		<spinbutton tooltip-text="Wait NUM seconds before taking a shot." editable="false" block-function-signals="true" range-min="0" range-max="100" range-step="1">
			<default>0</default>
			<variable>DELAY</variable>
			<sensitive>false</sensitive>
		</spinbutton>
		</hbox>
		<vseparator></vseparator>
		<hbox homogeneous="true">
		<checkbox>
			<label>Screenshot Quality :</label>
			<action>if false disable:QUALITY</action>
			<action>if true enable:QUALITY</action>
		</checkbox>
		<spinbutton tooltip-text="Image quality (1-100) high value means high size, low compression." editable="false" block-function-signals="true" range-min="0" range-max="100" range-step="5">
			<default>75</default>
			<variable>QUALITY</variable>
			<sensitive>false</sensitive>
		</spinbutton>	
		</hbox>
            </vbox>
	<hseparator height-request="5"></hseparator>
	<hbox homogeneous="true">
		<checkbox tooltip-text="When selecting a window, grab wm border too">
			<label>Grab Window border</label>
			<default>true</default>
			<variable>BORDER</variable>
		</checkbox>
	</hbox>
	</frame>
	<hbox homogeneous="true">
		<button width-request="100"><label>About</label><input file stock="gtk-about"></input><action>gtkdialog -c --program=ABOUT</action></button>
		<button width-request="100"><label>Cancel</label><input file stock="gtk-cancel"></input></button>
	</hbox>
</vbox>
</window>'

