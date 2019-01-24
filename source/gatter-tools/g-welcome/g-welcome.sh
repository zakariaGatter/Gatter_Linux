#!/bin/bash 

#----------------#
# Start Up Check #
#----------------#
if [ -f "$HOME/.config/autostart/g-welcome.desktop" ];then # For Openbox
	_AUTO="true"
else
	_AUTO="false"
fi 

#---------------#
# SET AUTOSTART #
#---------------#
AUTOSTART ()
{
if [ "$STARTUP" = "false" ] && [ "$_AUTO" = "true" ];then 
	rm $HOME/.config/autostart/g-welcome.desktop
elif [ "$STARTUP" = "true" ] && [ "$_AUTO" = "false" ];then 
	cp $HOME/.local/share/g-welcome/g-welcome.desktop $HOME/.config/autostart/g-welcome.desktop
fi
}

#---------------#
# CREATE Button #
#---------------#
CREATE ()
{
echo '
<button tooltip-text="'$4'" image-position="2" width-request="150">
	<label>"'$1'"</label>
	<width>32</width>
	<height>32</height>
	<input file icon="'$2'"></input>
	<action>'$3' &</action>
</button>
'
}

#-------------#
# MAIN DIALOG #
#-------------#
export WELCOME_DIALOG='
<window title="Gatter Welcome Screen" window_position="1" resizable="false" icon-name="g-welcome">
<vbox>
	<text wrap="false" use-markup="true" justify="2"><label>
"<span font='"'Terminus 10'"'>
<u><b>Welcome To Gatter Linux.</b></u>

<b>Gatter Linux</b> Is a free Operation System For Everyone to Use or Share or Remastered. 
This Distrobution for People who want A full Functional Openbox Window Manager out of box 
And for People Who Want Lightweight Operation System and much more customizable.
 
<b>Gattre Linux</b> Aims to Provide each User With Minimal collection of Software and tools: 
Web Browser, Media Player, Text editor, Image Viewer ... 

<b>I hope you Enjoy Using Gatter Linux </b></span>"
	</label></text>
	<frame>
		<hbox homogeneous="true">
			'"$(CREATE "Keyboard layout" "cs-keyboard" "g-key" "Change system keyboard Layout")"'
			'"$(CREATE "Gatter Software" "aptgate" "aptgate" "Cli Software Manager For Gatter Linux")"'
			'"$(CREATE "Drivers Manager" "jockey" "software-properties-gtk --open-tab=4" "Driver installer")"'
		</hbox>
		<hbox homogeneous="true">
			'"$(CREATE "Time Zone" "time-admin" "g-time" "Time and Date Manager")"'
			'"$(CREATE "System Language" "preferences-desktop-locale" "gnome-language-selector" "Change System language")"'
			'"$(CREATE "Gatter Settings" "g-settings" "g-settings" "System Settings for Gatter Linux")"'
		</hbox>
	</frame>
	<hbox homogeneous="true">
		<checkbox>
			<label>Gatter Welcome Startup</label>
			<variable>STARTUP</variable>
			<default>'"$_AUTO"'</default>
		</checkbox>
		<button tooltip-text=" Exit from Gatter Welcome " width-request="100" >
			<input file stock="gtk-quit"></input>
			<label> QUIT </label>
			<action>AUTOSTART</action>
			<action>EXIT:exit</action>
		</button>
	</hbox>
</vbox>
</window>
'

gtkdialog -c -p WELCOME_DIALOG
