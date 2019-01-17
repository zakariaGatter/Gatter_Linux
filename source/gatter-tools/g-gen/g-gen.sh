#!/usr/bin/gtkdialog -e 

: > /tmp/gen

BACKWORD='
<vbox>
<frame>
	<text use-markup="true" justify="2"><label>
"<span font='"'Terminus 11'"'>
<b>Take a text and output it backword </b>
	
Word or Phrase 

</span>"
	</label></text>
	<entry width-request="300">
	<variable>B_W_G</variable>
	</entry>
	<button width-request="100">
		<label>Generate</label>
		<input file stock="gtk-execute"></input>
		<action>g-backword $B_W_G > /tmp/gen</action>
	</button>
</frame>
</vbox>'

INTEGER='
<vbox>
<frame>
	<text use-markup="true" width-request="500"><label>
"<span font='"'Terminus 11'"'>
  The random List start from <b>[BEGIN]</b> and end at <b>[END]</b>
  <b>[NUMBER]</b> how many Random Number you want to see in Output
  <b>[COLUMNS]</b> how many columns you want to see in Output 
</span>"
	</label></text>
<hbox homogeneous="true">
	<vbox>
	<text><label>"Begin"</label></text>
	<spinbutton width-request="60" block-function-signals="true" range-min="1" range-max="100" range-step="1">
		<default>1</default>
		<variable>_B_</variable>
	</spinbutton>
	</vbox>
	<vbox>
	<text><label>"End"</label></text>
	<spinbutton width-request="60" block-function-signals="true" range-min="1" range-max="1000000" range-step="1">
		<default>10</default>
		<variable>_E_</variable>
	</spinbutton>
	</vbox>
	<vbox>
	<text><label>"Number"</label></text>
	<spinbutton width-request="60" block-function-signals="true" range-min="1" range-max="100" range-step="1">
		<default>3</default>
		<variable>_N_</variable>
	</spinbutton>
	</vbox>
	<vbox>
	<text><label>"Columns"</label></text>
	<spinbutton width-request="60" block-function-signals="true" range-min="1" range-max="100" range-step="1">
		<default>3</default>
		<variable>_C_</variable>
	</spinbutton>
	</vbox>
</hbox>
<button width-request="100">
	<label>Generate</label>
	<input file stock="gtk-execute"></input>
	<action>g-integer $_B_ $_E_ $_N_ $_C_ > /tmp/gen</action>
</button>
</frame>
</vbox>'

MAC='
<vbox>
<frame>
<text use-markup="true" width-request="500"><label>
"<span font='"'Terminus 11'"'><b>


		Generate a random MAC Address</b></span>


"</label></text>
<button width-request="100">
	<label>Generate</label>
	<input file stock="gtk-execute"></input>
	<action>g-mac > /tmp/gen</action>
</button>
</frame>
</vbox>'

PASSWORD='
<vbox>
<text use-markup="true" width-request="500"><label>"<span font='"'Terminus 11'"'><b>	    Generate a Complex Password randomly</b></span>"</label></text>
<frame>
<hbox homogeneous="true">
<button tooltip-text="Generate">
	<width>80</width>
	<height>80</height>
	<input file icon="badge-small"></input>
	<action>_PASSWORD_ &</action>
</button>
<vseparator></vseparator>
<vbox>
	<checkbox>
		<label>Alpha :</label>
		<variable>_ALPHA_</variable>
	</checkbox>
	<checkbox>
		<label>Number :</label>
		<variable>_NUMBER_</variable>
	</checkbox>
	<checkbox>
		<label>Punct :</label>
		<variable>_PUNCT_</variable>
	</checkbox>
</vbox>
</hbox>
<hseparator></hseparator>
<hbox homogeneous="true">
	<text use-markup="true"><label>"<span font='"'Terminus 11'"'><b>Char Number :</b></span>"</label></text>
	<spinbutton width-request="60" block-function-signals="true" range-min="8" range-max="100" range-step="1">
		<default>8</default>
		<variable>_PN_</variable>
	</spinbutton>
</hbox>
</frame>
</vbox>
'

_PASSWORD_ () {
if [ "$_ALPHA_" = "true" -a "$_NUMBER_" = "true" -a "$_PUNCT_" = "true" ];then 
	g-password all "$_PN_" > /tmp/gen
elif [ "$_ALPHA_" = "true" -a "$_NUMBER_" = "true" ];then
	g-password alnum "$_PN_" > /tmp/gen
elif [ "$_ALPHA_" = "true" ];then 
	g-password alpha "$_PN_" > /tmp/gen
elif [ "$_NUMBER_" = "true" ];then 
	g-password num "$_PN_" > /tmp/gen
elif [ "$_PUNCT_" = "true" ];then
	g-password num "$_PN_" > /tmp/gen
fi
}

STRING='
<vbox>
<text use-markup="true" width-request="500"><label>"<span font='"'Terminus 11'"'><b>	    Generate a random String </b></span>"</label></text>
<frame>
<hbox homogeneous="true">
<button tooltip-text="Generate">
	<width>80</width>
	<height>80</height>
	<input file icon="badge-small"></input>
	<action>_STRING_ &</action>
</button>
<vseparator></vseparator>
<vbox>
	<checkbox>
		<label>Number :</label>
		<variable>_S_N_</variable>
	</checkbox>
	<checkbox>
		<label>Lower :</label>
		<variable>_S_L_</variable>
	</checkbox>
	<checkbox>
		<label>Upper :</label>
		<variable>_S_U_</variable>
	</checkbox>
</vbox>
</hbox>
<hseparator></hseparator>
<hbox homogeneous="true">
	<hbox>
	<text use-markup="true"><label>"<span font='"'Terminus 11'"'><b>Chars Number :</b></span>"</label></text>
	<spinbutton width-request="60" block-function-signals="true" range-min="1" range-max="100" range-step="1">
		<default>10</default>
		<variable>_SN_</variable>
	</spinbutton>
	</hbox>
	<hbox>
	<text use-markup="true"><label>"<span font='"'Terminus 11'"'><b>Lines Number :</b></span>"</label></text>
	<spinbutton width-request="60" block-function-signals="true" range-min="5" range-max="100" range-step="1">
		<default>5</default>
		<variable>_SL_</variable>
	</spinbutton>
	</hbox>
</hbox>
</frame>
</vbox>
'

_STRING_ () {
if [ "$_S_N_" = "true" -a "$_S_L_" = "true" -a "$_S_U_" = "true" ];then 
	g-string all "$_SL_" "$_SN_" > /tmp/gen
elif [ "$_S_N_" = "true" ];then 
	g-string number "$_SL_" "$_SN_" > /tmp/gen
elif [ "$_S_L_" = "true" ];then 
	g-string lower "$_SL_" "$_SN_" > /tmp/gen
elif [ "$_S_U_" = "true" ];then
	g-string upper "$_SL_" "$_SN_" > /tmp/gen
fi
}

export MAIN_DIALOG='
<window width-request="500" title=" Gatter Generator " icon-name="badge-small" resizable="false" window_position="1">
<vbox>
<pixmap>
<width>48</width>
<height>48</height>
<input file icon="g-gen"></input>
</pixmap>
<text use-markup="true" justify="2"><label>"<span font='"'Terminus 11'"'><b>Gatter Generator</b></span>"</label></text>
<notebook labels="Integer|Backword|Mac|Password|String">
	'"$INTEGER"'
	'"$BACKWORD"'
	'"$MAC"'
	'"$PASSWORD"'
	'"$STRING"'
</notebook>
<vbox>
<edit editable="false" auto-refresh="true">
	<variable>GEN</variable>
	<input file>/tmp/gen</input>
</edit>
</vbox>
<button width-request="100">
	<label>Cancel</label>
	<input file stock="gtk-cancel"></input>
</button>
</vbox>
</window>'
