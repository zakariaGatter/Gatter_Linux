#! /usr/bin/gtkdialog -e

date +%d/%m/%Y > /tmp/date
date +%H:%M > /tmp/time

LIST_TIMEZONE () {
for L in $(timedatectl list-timezones ); do 
	echo "<item>$L</item>"
done
}

CURRENT_TIMEZONE=$(timedatectl | awk '/Time zone:/{print $3}')

SET_T_T_D () {
if [ "$CURRENT_TIMEZONE" != "$TIME_Z" ];then 
	echo "$TIME_Z" | gsu "tee /etc/timezone"
	sudo dpkg-reconfigure --frontend noninteractive tzdata
fi

if [ "$(cat /tmp/time)" != "$C_T" ];then 
	gsu date +%H:%M -s "$C_T"
fi

if [ "$(cat /tmp/date)" != "$C_D" ];then 
	gsu date +%d/%m/%Y -s "$C_D"
fi
}

export MAIN_DIALOG='
<window title="Time Gate" position="2" icon-name="time-admin">
<vbox>
<pixmap>
	<width>48</width>
	<height>48</height>
	<input file icon="time-admin"></input>
</pixmap>
<text use-markup="true" justify="2">
	<label>
		"<span font='"'Terminus 11'"'>Change Time Zone with List of all avariable in the system </span>"
	</label>
</text>
<frame>
	<text use-markup="true" justify="2"><label>"Current Time Zone"</label></text>
	<comboboxtext width-request="200">
		'"$(LIST_TIMEZONE)"'
		<variable>TIME_Z</variable>
		<default>'"$CURRENT_TIMEZONE"'</default>
	</comboboxtext>
</frame>
<hbox homogeneous="true">
<frame>
<text use-markup="true" justify="2">
	<label>
		"<span font='"'Terminus 11'"'>Change Time [HH:MM]</span>"
	</label>
</text>
<entry>
	<input file>/tmp/time</input>
	<variable>C_T</variable>
</entry>
</frame>
<frame>
<text use-markup="true" justify="2">
	<label>
		"<span font='"'Terminus 11'"'>Change Date [DD/MM/YYYY]</span>"
	</label>
</text>
<entry>
	<input file>/tmp/date</input>
	<variable>C_D</variable>
</entry>
</frame>
</hbox>
<hbox homogeneous="true">
<button width-request="100">
	<input file stock="gtk-execute"></input>
	<label> Execute </label>
	<action>SET_T_T_D &</action>
</button>
<button width-request="100">
	<input file stock="gtk-execute"></input>
	<label> use Dpkg </label>
	<action>x-terminal-emulator -e "sudo dpkg-reconfigure tzdata" &</action>
</button>
<button width-request="100">
	<input file stock="gtk-cancel"></input>
	<label> Cancel </label>
</button>
</hbox>
</vbox>
</window>
'
