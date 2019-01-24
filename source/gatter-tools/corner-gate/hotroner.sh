#!/usr/bin/gtkdialog -e

CONF_FILE="$HOME/.config/corner-gaterc"

if [ ! -f "$CONF_FILE" ];then 
echo "+ Top_Right=ls
+ Top_Left=ls
+ Bottom_Right=ls
+ Bottom_Left=ls" > $CONF_FILE
fi

_T_L_C=$(awk -F = '/Top_Left/{print $2}' $CONF_FILE)
_T_R_C=$(awk -F = '/Top_Right/{print $2}' $CONF_FILE)
_B_L_C=$(awk -F = '/Bottom_Left/{print $2}' $CONF_FILE)
_B_R_C=$(awk -F = '/Bottom_Right/{print $2}' $CONF_FILE)

_T_L_K=$(awk '/Top_Left/{print $1}' $CONF_FILE)
_T_R_K=$(awk '/Top_Right/{print $1}' $CONF_FILE)
_B_L_K=$(awk '/Bottom_Left/{print $1}' $CONF_FILE)
_B_R_K=$(awk '/Bottom_Right/{print $1}' $CONF_FILE)

EXEC_CORNER() {
echo "$([ "$_Top_R" = "true" ] && echo '+' || echo "-") Top_Right=$_Top_R_Cmd
$([ "$_Top_L" = "true" ] && echo '+' || echo "-") Top_Left=$_Top_L_Cmd
$([ "$_Bot_R" = "true" ] && echo '+' || echo "-") Bottom_Right=$_Bot_R_Cmd
$([ "$_Bot_L" = "true" ] && echo '+' || echo "-") Bottom_Left=$_Bot_L_Cmd" > $CONF_FILE

pkill corner-gate-exec 

pkill xdotool

corner-gate-exec
}

export MAIN_DIALOG='
<window width-request="600" title="Corner Gate" icon-name="corner-gate">
<vbox>
	<pixmap><width>48</width><input file icon="corner-gate"></input></pixmap>
	<text use-markup="true"><label>"<span font='"'Terminus Bold 12'"'>Corner Gate Settings</span>"</label></text>
	<frame>
		<hbox homogeneous="true">
			<vbox>
			<checkbox>
				<default>'"$([ "$_T_L_K" = "+" ] && echo true || echo false)"'</default>
				<label>Top Left</label>
				<variable>_Top_L</variable>
			</checkbox>
				<hbox>
				<entry fs-title="Add Command" fs-folder="/usr/bin">
					<default>'"$_T_L_C"'</default>
					<variable>_Top_L_Cmd</variable>
				</entry>
				<button>
					<input file stock="gtk-open"></input>
					<action function="fileselect">_Top_L_Cmd</action>
				</button>
				</hbox>
			</vbox>
			<vbox>
			<checkbox>
				<default>'"$([ "$_T_R_K" = "+" ] && echo true || echo false)"'</default>
				<label>Top Right</label>
				<variable>_Top_R</variable>
			</checkbox>
				<hbox>
				<entry fs-title="Add Command" fs-folder="/usr/bin">
					<default>'"$_T_R_C"'</default>
					<variable>_Top_R_Cmd</variable>
				</entry>
				<button>
					<input file stock="gtk-open"></input>
					<action function="fileselect">_Top_R_Cmd</action>
				</button>
				</hbox>
			</vbox>
		</hbox>
		<pixmap><width>96</width><input file icon="display"></input></pixmap>
		<hbox homogeneous="true">
			<vbox>
			<checkbox>
				<default>'"$([ "$_B_L_K" = "+" ] && echo true || echo false)"'</default>
				<label>Bottom Left</label>
				<variable>_Bot_L</variable>
			</checkbox>
				<hbox>
				<entry fs-title="Add Command" fs-folder="/usr/bin">
					<default>'"$_B_L_C"'</default>
					<variable>_Bot_L_Cmd</variable>
				</entry>
				<button>
					<input file stock="gtk-open"></input>
					<action function="fileselect">_Bot_L_Cmd</action>
				</button>
				</hbox>
			</vbox>
			<vbox>
			<checkbox>
				<default>'"$([ "$_B_R_K" = "+" ] && echo true || echo false)"'</default>
				<label>Bottom Right</label>
				<variable>_Bot_R</variable>
			</checkbox>
				<hbox>
				<entry fs-title="Add Command" fs-folder="/usr/bin">
					<default>'"$_B_R_C"'</default>
					<variable>_Bot_R_Cmd</variable>
				</entry>
				<button>
					<input file stock="gtk-open"></input>
					<action function="fileselect">_Bot_R_Cmd</action>
				</button>
				</hbox>
			</vbox>
		</hbox>
	</frame>
	<hbox homogeneous="true">
		<button width-request="100">
			<label>About</label>
			<input file stock="gtk-about"></input>
			<action>gtkdialog -c -p ABOUT</action>
		</button>
		<button width-request="100">
			<label>Excute</label>
			<input file icon="gtk-execute"></input>
			<action>EXEC_CORNER</action>
		</button>
		<button width-request="100">
			<label>Cancel</label>
			<input file stock="gtk-cancel"></input>
		</button>
	</hbox>
</vbox>
</window>'
