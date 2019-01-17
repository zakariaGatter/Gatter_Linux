#! /usr/bin/gtkdialog -e

#-------------------#
# CREATE Big Button #
#-------------------#
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

#----------------------#
# CREATE Smaple Button #
#----------------------#
create ()
{
echo '
<button tooltip-text="'$3'">
	<width>24</width>
	<height>24</height>
	<input file icon="'$1'"></input>
	<action>'$2' &</action>
</button>
'	
}

export PERSONAL='
<vbox>
	<hbox homogeneous="true">
		'"$(CREATE "Appearance" "preferences-desktop-theme" "lxappearance" "Customizes look and feel of your desktop and applications")"'
		'"$(CREATE "Notificatons" "xfce4-notifyd" "xfce4-notifyd-config" "Customize how notifications appear on your screen")"'
		'"$(CREATE "Openbox Config" "preferences-system-windows" "obconf" "Tweak settings for Openbox")"'
	</hbox>
	<hbox homogeneous="true">
		'"$(CREATE "Desktop Preferences" "g-wall" "g-wall" "Change Desktop Wallpaper")"'
		'"$(CREATE "Compton Config" "wmtweaks" "compton-conf" "Configure Compton window effects")"'
		'"$(CREATE "Panel Preferences" "cs-panel" "tint2conf" "Change Panel Preferences")"'
	</hbox>
	<hbox homogeneous="true">
		'"$(CREATE "Pcmanfm Settings" "folder-saved-search" "pcmanfm --show-pref=1" "Configure the PcmanFm file manager")"'
		'"$(CREATE "Autostart" "session-properties" "gnome-session-properties" "Manager Autostart Application For Openbox")"'
	</hbox>
</vbox>
'

export HARDWARE='
<vbox>
	<hbox homogeneous="true">
		'"$(CREATE "Display Manager" "video-display" "lxrandr" "Change screen resolution and configure external monitors")"'
		'"$(CREATE "Keyboard Shutcut" "key_bindings" "obkey" "Graphical key editor for openbox")"'
		'"$(CREATE "Power Manager" "xfpm-ac-adapter" "xfce4-power-manager-settings" "Settings for the Xfce Power Manager")"'
	</hbox>
	<hbox homogeneous="true">
		'"$(CREATE "Mouse & Keyboard" "mouse" "lxinput" "Configure keyboard, mouse, and other input devices")"'
		'"$(CREATE "Additional Drivers" "jockey" "software-properties-gtk --open-tab=4" "Configure third-party and proprietary drivers")"'
		'"$(CREATE "Volume Control" "preferences-desktop-sound" "pavucontrol" "Adjust the volume level")"'
	</hbox>
	<hbox homogeneous="true">
		'"$(CREATE "Keyboard Layout" "g-key" "g-key" "Change system Keyboard layout")"'
	</hbox>
</vbox>
'

export SYSTEM='
<vbox>
	<hbox homogeneous="true">
		'"$(CREATE "Lightdm GTK" "lightdm-gtk-greeter-settings" "lightdm-gtk-greeter-settings-pkexec" "")"'
		'"$(CREATE "Date & Time" "time-admin" "g-time" "Change system time, date, and timezone")"'
		'"$(CREATE "Network Connections" "preferences-system-network" "nm-connection-editor" "Manage and change your network connection settings")"'
	</hbox>
	<hbox homogeneous="true">
		'"$(CREATE "Software & Updates" "software-properties" "software-properties-gtk" "Configure the sources for installable software and updates")"'
		'"$(CREATE "Screen Saver" "preferences-desktop-screensaver" "xscreensaver-demo" "Configure screensaver for your session")"'
		'"$(CREATE "Language Support" "preferences-desktop-locale" "gnome-language-selector" "Configure multiple and native language support on your system")"'
	</hbox>
	<hbox homogeneous="true">
		'"$(CREATE "Menu Editor" "alacarte" "obmenu" "Add or remove applications from the menu")"'
		'"$(CREATE "Partition Manager" "gparted" "/usr/sbin/gparted" "Create, reorganize, and delete partitions")"'
	</hbox>
</vbox>
'

export MAIN_DIALOG='
<window title="Gatter Control Center" window_position="1" resizable="false" icon-name="preferences-desktop">
<vbox>
	<pixmap>
		<input file>'"$HOME/.local/share/g-settings/settings-logo.png"'</input>
	</pixmap>
	<text use-markup="true">
		<label>"<span font='"'Terminus 11'"'><b> Gatter Control Center </b></span>"</label>
	</text>
<notebook labels="Personal|Hardware|System">
	'"$PERSONAL"'
	'"$HARDWARE"'
	'"$SYSTEM"'
</notebook>
<hbox>
'"$(create "system-file-manager" "pcmanfm $HOME" "Use File manager")"'
'"$(create "terminal" "x-terminal-emulator" "Use terminal Emulator")"'
'"$(create "text-editor" "geany" "Use Text Editor")"'
'"$(create "utilities-system-monitor" "lxtask" "Manage running processes")"'
'"$(create "emblem-favorite" "gtk-icons" "List of gtk icons")"'
'"$(create "xfce4-appfinder" "g-apps" "Application Menu")"'
'"$(create "gnome-logout" "g-exit" "lanch Logout Dialog")"'
'"$(create "gtk-cancel" "EXIT:exit" "Cancel Gatter Settings")"'
</hbox>
</vbox>
</window>
'