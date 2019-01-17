#! /usr/bin/gtkdialog -e
 
export TEXTDOMAIN=hash-gate
export OUTPUT_CHARSET=UTF-8

[ ! -f /tmp/hash1 ] && touch /tmp/hash1
[ ! -f /tmp/hash2 ] && touch /tmp/hash2

#---------#
# SUCCESS #
#---------#
export SUCCESS='
<window title="Compare Hashes" position="1" icon-name="gtkhash">
<vbox>
	<pixmap>
		<width>64</width>
		<height>64</height>
		<input file icon="gtk-ok"></input>
	</pixmap>
<frame>
	<text use-markup="true" justify="2">
		<label>
"<b>'"$FILE1"'</b> 
and
<b>'"$FILE2"'</b>

Have the Same hash, they are maybe the same file "
		</label>
	</text>
</frame>
	<hbox>
	<button cancel></button>
	</hbox>
</vbox>
</window>
'

#-------#
# ERROR #
#-------#
export ERROR='
<window title="Compare Hashes" position="1" icon-name="gtkhash">
<vbox>
	<pixmap>
		<width>64</width>
		<height>64</height>
		<input file icon="gtk-dialog-warning"></input>
	</pixmap>
<frame>
	<text use-markup="true" justify="2">
		<label>
"<b>'"$FILE1"'</b> 
and
<b>'"$FILE2"'</b>

Havent the Same hash "
		</label>
	</text>
</frame>
	<hbox>
	<button cancel></button>
	</hbox>
</vbox>
</window>
'

#---------#
# LICENSE #
#---------#
export LICENSE_DIALOG='
<window title="License" resizable="false" icon-name="gtk-info" width-request="550" height-request="250">
<vbox>
	<edit editable="false">
		<default>
"
Hash Gate is free software: you can redistribute it and/or modify
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
		<input file icon="hash-gate"></input>
	</pixmap>
	<text use-markup="true" justify="2">
		<label>
"hash Gate 0.1 :
Hash Calculate For Gatter Linux 

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

#------#
# HASH #
#------#
HASH ()
{
if [ "$CAL" = "true" -a -n "$FILE1" ];then 
	($1 $FILE1 | awk '{print $1}') > /tmp/hash1
fi

if [ "$COM" = "true" -a -n "$FILE1" -a -n "$FILE2" ];then 
	($1 $FILE1 | awk '{print $1}') > /tmp/hash1
	($1 $FILE2 | awk '{print $1}') > /tmp/hash2
	
	[ -z "$FILE1" -o -z "$FILE2" ] && return
	
	if [ "$($1 $FILE1 | awk '{print $1}')" = "$($1 $FILE2 | awk '{print $1}')" ];then
		gtkdialog -c --program=SUCCESS
	else
		gtkdialog -c --program=ERROR
	fi
fi
}

#-----------#
# SAVE HASH #
#-----------#
export SAVE_HASH='
<window title="SAVE Hashes" position="1" icon-name="gtkhash">
<vbox>
	<text use-markup="true">
		<label>
			"<b><span font='"'Terminus Bold 14'"'>Hash</span>__<span font='"'Terminus Bold 14'"' color='"'#4E4E4E'"'>GATE</span></b>"
		</label>
	</text>
	<hbox homogeneous="true">
		<vbox>
			<text><label> File Name :</label></text>
			<entry><variable>SAVE_NAME</variable></entry>
		</vbox>
		<vbox>
			<text><label> Directory Name :</label></text>
		<comboboxtext>
			<variable>SAVE_DIR</variable>
			'"$(ls $HOME | while read DIR ;do [ -d "$HOME/$DIR" ] && echo "<item>$DIR</item>";done)"'
		</comboboxtext>
		</vbox>
	</hbox>
	<hbox>
	<button width-request="100">
		<label>Save</label>
		<input file stock="gtk-save"></input>
		<action>[ "$CAL" = "true" ] && echo "$(cat /tmp/hash1) --> $FILE1" >> ~/$SAVE_DIR/$SAVE_NAME</action>
		<action>[ "$COM" = "true" ] && echo "$(cat /tmp/hash1) --> $FILE1 \n$(cat /tmp/hash2) --> $FILE2" >> ~/$SAVE_DIR/$SAVE_NAME</action>
		<action>EXIT:exit</action>
	</button>
	<button width-request="100">
		<label>Cancel</label>
		<input file stock="gtk-cancel"></input>
	</button>
	</hbox>
</vbox>
</window>
'

#-------------#
# MAIN DIALOG #
#-------------#
export MAIN_DIALOG='
<window title="Hash Gate" position="1" icon-name="gtkhash" width-request="500">
<vbox>
	<text use-markup="true">
		<label>
			"<b><span font='"'Terminus Bold 16'"'>Hash</span>  <span font='"'Terminus Bold 16'"' color='"'#4E4E4E'"'>Gate</span></b>"
		</label>
	</text>
	<hbox>
		<frame>
			<text><label> First File :</label></text>
			<hbox>
				<entry>
					<variable>FILE1</variable>
				</entry>
				<button>
					<input file stock="gtk-open"></input>
					<variable>FFILE1</variable>
					<action function="fileselect">FILE1</action>
				</button>
			</hbox>
				<entry auto-refresh="true" editable="false">
					<input file>/tmp/hash1</input>
					<variable>OUT1</variable>
				</entry>
			<hseparator height-request="5"></hseparator>
			<text><label> Second File :</label></text>
			<hbox>
				<entry>
					<variable>FILE2</variable>
					<sensitive>false</sensitive>
				</entry>
				<button>
					<input file stock="gtk-open"></input>
					<variable>FFILE2</variable>
					<action function="fileselect">FILE2</action>
					<sensitive>false</sensitive>
				</button>
			</hbox>
				<entry auto-refresh="true">
					<input file>/tmp/hash2</input>
					<variable>OUT2</variable>
					<sensitive>false</sensitive>
				</entry>
			<hseparator height-request="5"></hseparator>
			<hbox homogeneous="true">
				<radiobutton tooltip-text="Calculate hash for one File">
					<label> Calculate Hash</label>
					<variable>CAL</variable>
					<default>true</default>
				</radiobutton>
				<radiobutton tooltip-text="Compare hash between two Files ">
					<label> Compare Hashes </label>
					<variable>COM</variable>
					<action>if false disable:FILE2</action>
					<action>if true enable:FILE2</action>
					<action>if false disable:FFILE2</action>
					<action>if true enable:FFILE2</action>
					<action>if false disable:OUT2</action>
					<action>if true enable:OUT2</action>
				</radiobutton>
			</hbox>
			<hseparator height-request="5"></hseparator>
			<hbox homogeneous="true">
				<button width-request="120">
					<label> Save Hash </label>
					<input file stock="gtk-save"></input>
					<action>gtkdialog -c --program=SAVE_HASH &</action>
				</button>
				<button width-request="100">
					<label> Clear </label>
					<input file stock="gtk-clear"></input>
					<action>echo > /tmp/hash1</action>
					<action>echo > /tmp/hash2</action>
				</button>
			</hbox>
		</frame>
		<frame>
		<button width-request="80" tooltip-text="Calculate hash with sha1 " homogeneous="true">
			<input file stock="gtk-execute"></input>
			<label>"SHA1    "</label>
			<action>HASH '"sha1sum"' &</action>
			<action>refresh:OUT1</action>
			<action>refresh:OUT2</action>
		</button>
		<button width-request="80" tooltip-text="Calculate hash with sha2 24 bit " homogeneous="true">
			<input file stock="gtk-execute"></input>
			<label>SHA2 24</label>
			<action>HASH '"sha224sum"' &</action>
			<action>refresh:OUT1</action>
			<action>refresh:OUT2</action>
		</button>
		<button width-request="80" tooltip-text="Calculate hash with sha2 56 bit " homogeneous="true">
			<input file stock="gtk-execute"></input>
			<label>SHA2 56</label>
			<action>HASH '"sha256sum"' &</action>
			<action>refresh:OUT1</action>
			<action>refresh:OUT2</action>
		</button>
		<button width-request="80" tooltip-text="Calculate hash with sha3 84 bit " homogeneous="true">
			<input file stock="gtk-execute"></input>
			<label>SHA3 84</label>
			<action>HASH '"sha384sum"' &</action>
			<action>refresh:OUT1</action>
			<action>refresh:OUT2</action>
		</button>
		<button width-request="80" tooltip-text="Calculate hash with sha5 12 bit " homogeneous="true">
			<input file stock="gtk-execute"></input>
			<label>SHA5 12</label>
			<action>HASH '"sha512sum"' &</action>
			<action>refresh:OUT1</action>
			<action>refresh:OUT2</action>
		</button>
		<button width-request="80" tooltip-text="Calculate hash with md5 " homogeneous="true">
			<input file stock="gtk-execute"></input>
			<label>"MD5     "</label>
			<action>HASH '"md5sum"' &</action>
			<action>refresh:OUT1</action>
			<action>refresh:OUT2</action>
		</button>
		<hseparator height-request="5"></hseparator>
			<button width-request="80">
				<input file stock="gtk-about"></input>
				<label>About</label>
				<action>gtkdialog -c --program=ABOUT</action>
			</button>
			<button width-request="80">
				<input file stock="gtk-cancel"></input>
				<label>Cancel</label>
			</button>
		</frame>
	</hbox>
</vbox>
</window>
'
