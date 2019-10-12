#!/bin/bash

#     ██               ██     ████████              ██          
#    ████    ██████   ░██    ██░░░░░░██            ░██          
#   ██░░██  ░██░░░██ ██████ ██      ░░   ██████   ██████  █████ 
#  ██  ░░██ ░██  ░██░░░██░ ░██          ░░░░░░██ ░░░██░  ██░░░██
# ██████████░██████   ░██  ░██    █████  ███████   ░██  ░███████
#░██░░░░░░██░██░░░    ░██  ░░██  ░░░░██ ██░░░░██   ░██  ░██░░░░ 
#░██     ░██░██       ░░██  ░░████████ ░░████████  ░░██ ░░██████
#░░      ░░ ░░         ░░    ░░░░░░░░   ░░░░░░░░    ░░   ░░░░░░
# AptGate  	= Is a Script Shell To Install Some Of the Most Useful Software
# <Zakaria Gatter> = <zakaria.gatter@gmail.com>

# # # # Color # # # #
BRed='\e[1;31m'     #
BGreen='\e[1;32m'   #
BYellow='\e[1;33m'  #
BBlue='\e[1;34m'    #
BPurple='\e[1;35m'  #
BCyan='\e[1;36m'    #
BWhite='\e[1;37m'   #
# # # # # # # # # # #
Off='\e[0m'         #
# # # # # # # # # # #

_FZF_="$HOME/.fzf/bin/fzf"

#------------#
# PRINT LINE #
#------------#
print_line () {
	printf "%$(tput cols)s\n"|tr ' ' '='
}

#-------------#
# PRINT TITLE #
#-------------#
print_title () {
	clear
	print_line
	echo -e "${BBlue} # \t ${BWhite} $1 ${Off}"
	print_line
	echo ""
}

#----------------#
# PAUSE FUNCTION #
#----------------#
pause_func () {
	echo -e "${Off}"
	print_line
	echo -en "${BWhite}Press ${BGreen}[ENTER] ${BWhite}to Continue ...${Off} "
	read ReadEnterKey
}

#---------------#
# Check Network #
#---------------#
Check_Network () {
    clear 
	echo -e "${BYellow} ==>${BGreen} Test :${BWhite} Check Network Connection${BRed} ... ${Off}"
	echo -e "${BBlue} -->${BWhite} Please Wait${BRed} ... ${Off}"
if ! ping -c 3 google.com > /dev/null ;then
    clear
	print_line
		echo -e "${BYellow} ==>${BPurple} Worning :${BWhite} You Dont Have Network Acces\n\t Set Up Your Connection If You Want Install Application ${Off}"
	pause_func
fi
	}
	
#------------------#
# PPA ADD FUNCTION #
#------------------#
PPA_Func () {
	print_title " Add PPA "
	echo -e "${BWhite} PPA ${BCyan} >: ${BGreen} $1 \n ${BWhite} Will be Add ${Off}"
	print_line
		if sudo apt-add-repository -y "$1" ;then
			print_line
            if [ "$2" = "yes" ] ;then 
                print_title "Add PPA "
                sudo apt update
            else
                while true ; do
                    echo -e "${BWhite} Do You Want to Update MirrorList ??${BRed} [Y/n] "
                    echo -en "${BBlue} >: ${Off}"
                    read update_opt
                    case "$update_opt" in
                        Y|y )
                            print_title "Add PPA "
                            sudo apt update
                            break
                        ;;
                        N|n )
                            # Nothing to do here
                            break
                        ;;
                        * )
                            # There is nothing to do
                        ;;
                    esac
                done
            fi
		else
			print_line
			echo -e "${BYellow} ==> ${BRed}ERROR :${BWhite} The PPA Not Valid For This Release or You type PPA Name Wrong ${Off}"
		fi
	pause_func
}

#---------------------#
# PPA REMOVE FUNCTION #
#---------------------#
PPAR_Func () {
	print_title " REMOVE PPA "
	echo -e "${BWhite} PPA ${BCyan} >: ${BGreen} $1 \n ${BWhite} Will be REMOVE ${Off}"
	print_line
		sudo apt-add-repository -r "$1"
	pause_func
}

#----------#
# List_PPA #
#----------#
List_PPA () {
for APT in $(find /etc/apt/ -name \*.list);do
	grep -o "^deb http://ppa.launchpad.net/[a-z0-9\-]\+/[a-z0-9\-]\+" "$APT" | while read ENTRY ; do
        USER=$(echo "$ENTRY" | cut -d/ -f4)
        PPA=$(echo "$ENTRY" | cut -d/ -f5)
		echo "ppa:$USER/$PPA"
	done
done
}

#-----------#
# Check PPA #
#-----------#
Check_PPA () {
[ -z "$(echo "$(List_PPA)" | grep "^$1")" ] && echo -e "${Off}[ ]${Off}" || echo -e "${Off}[${BRed}X${Off}]${Off}"
}
	
#-------------------------------------------#
# Check if the Package is all ready install #
#-------------------------------------------#
Check () {
(which "$1" &> /dev/null ) && echo -e "${Off}[${BRed}X${Off}]${Off}" || echo -e "${BWhite}[ ]${Off}"
}

#------------------#
# INSTALL FUNCTION #
#------------------#
Install_Func () {
	print_title " Install Packages "
	echo -e "${BWhite} Packages ${BCyan} >:\n ${BGreen} $@ \n\t ${BWhite} Will be Install ${Off}"
	print_line
	sleep 1
		sudo apt install "$@"
	pause_func
}

#---------------------------#
# Remove old config Packges #
#---------------------------#
_Remove_old_config_() {
    print_title " Remove old Applications Config Files"
    LIST_CONF_APP=$(dpkg -l | awk '/^rc/{print $2}')
    
    if [ -n "$LIST_CONF_APP" ];then
        echo -e "${BWhite} $(echo $LIST_CONF_APP | column) ${Off} "
        print_line
        sudo dpkg --purge $(dpkg -l | awk '/^rc/{print $2}')
    else 
        echo -e "${BWhite} NO Packages to Remove ${Off}"
    fi 
    pause_func
}

#----------------#
# Locate Pckages #
#----------------#
_Locale_pkg_ () {
    print_title "Locate Packages Files "
    echo -e "${BBlue} -->${BWhite} Please Maxemize Window For best Preview"
    echo -e "${BBlue} -->${BWhite} Press${BYellow} <Esc>${BWhite} To Exit ${Off}"
    pause_func
    dpkg -l | awk '/^ii/{print $2}' | "$_FZF_" -e --prompt="Local Files For :>: " --reverse --color=16 --preview="dpkg -L {}"
}

#---------------#
# Update System #
#---------------#
_Update_system_() {
    print_title "Update System "
    sudo apt update
    pause_func
}

#---------------#
# Clean Pakages #
#---------------#
_Clean_pkg_() {
    print_title " Clean Old Packages Cache "
    if [ -n "$(ls /var/cache/apt/archives/*.deb 2> /dev/null)" ];then
        echo -e "${BWhite} Total Cache : ${BBlue}$(du -hc /var/cache/apt/archives/*.deb | awk '/total$/{print $1}') ${Off}"
        print_line
        sudo rm -rvf /var/cache/apt/archives/*.deb
    else
        echo -e "${BWhite} There is No Cache Packages ${Off}"
    fi
    pause_func
}

#-------------#
# REMOVE PKGS #
#-------------#
_RM_PKG_() {
while true ; do
    print_title "Remove Packages"
        echo -e "${BBlue} -->${BWhite} Enable multi-select with${BCyan} <tab>${BWhite} / ${BCyan} <shift-tab> "
        echo -e "${BBlue} -->${BWhite} Choose${BRed} \"Back\"${BWhite} To Return To Main Menu ${Off} "
    pause_func
        remove_pkg=$(echo -e "$(dpkg -l | grep "^ii" | awk '{print $2}' ) \nBack" | "$_FZF_" -e -m --prompt="Select Package to Remove :>: " --reverse --color=16)
        if [ "$remove_pkg" = "Back" -o -z "$remove_pkg" ];then
            break
        else
            clear
            echo -e "${BBlue} --> "
            echo -e "${BRed} $remove_pkg" | tr "\n" " "
            echo -e "${BWhite} Will be Remove from The System ${Off} "
            print_line
            sudo apt remove $remove_pkg
            pause_func
        fi
break
done
}

#----------#
# ADD REPO #
#----------#
_ADD_REPO_() {
while true ; do
    print_title "Add Repository "
        echo -e "${BCyan}List Install PPA's \n"
        echo -e "${BWhite}$(List_PPA) ${Off}\n"
    print_line
        echo -en "\t ${BWhite}Type the Repository Name or ${BRed}\"B\" ${BWhite}to Back${BCyan} >: ${Off}"
        read repo
        if [ "$repo" = "b" -o "$repo" = "B" ];then
                break
        else
                PPA_Func "$repo"
        fi
done
}

#------------#
# Remove PPA #
#------------#
_RM_REPO_() {
while true ; do
    print_title "Remove Repository"
        echo -e "${BBlue} -->${BWhite} Choose${BRed} \"Back\"${BWhite} To Return To Main Menu ${Off} "
    pause_func
    remove_ppa=$(echo -e "$(List_PPA) \nBack" | "$_FZF_" -e --prompt="Select PPA to Remove :>: " --reverse --color=16)
    if [ "$remove_ppa" = "Back" -o -z "$remove_ppa" ];then
        break
    else
        PPAR_Func "$remove_ppa"
    fi
done
}

#-------------#
# INSTALL DEB #
#-------------#
_INS_DEB_() {
Deb_file=$(cd $HOME && yad --file --title="Deb File Select" --window-icon="AptGate" --width=600 --height=450 --file-filter="*.deb" --multiple)
print_title " Install Deb Package "
if [ -n "$Deb_file" ];then 
    echo -e "\t${BCyan} --> :${BGreen}  $Deb_file "
    echo -e "\t\t${BWhite} Will Be Install ${Off}"
print_line
    sudo dpkg -i "$(echo $Deb_file | tr "|" " ")"
print_line
    echo -e "${BCyan} --> :${BWhite} Install Deb Depandess ${Off}"
    sudo apt-get install -f
print_line
    echo -e "${BCyan} --> : ${BWhite}Reinstall Deb Package ${Off}"
    sudo dpkg -i "$Deb_file"
else
    echo -e "${BWhite} No Deb File Selected  ${Off}"
fi 
pause_func
}

#--------------#
# INSTALL PKGS #
#--------------#
_INSTALL_PKG() {
while true ; do
print_title "Install Packages"
echo -e "${BBlue} -->${BWhite} Enable multi-select with${BPurple} <tab>${BWhite} /${BPurple} <shift-tab>"
echo -e "${BBlue} -->${BWhite} Choose${BRed} \"Back\"${BWhite} To Return To Main Menu  ${Off}"
pause_func
install_pkg=$(echo -e "$(apt-cache pkgnames | sort) \nBack" | "$_FZF_" -e -m --prompt="Select Package to Install :>: " --reverse --color=16)
_install_pkg_=$(echo $install_pkg | tr "\n" " ")
if [ "$install_pkg" = "Back"  -o -z "$install_pkg" ];then
    break
else
    Install_Func $( echo "$_install_pkg_")
    break
fi
done
}

#------------------#
# PACKAGEs Details #
#------------------#
_DETAIL_() {
print_title "Detail Installed Packages"
echo -e "${BBlue} -->${BWhite} Please Maxemize Window For best Preview"
echo -e "${BBlue} -->${BWhite} Press${BYellow} <Esc>${BWhite} To Exit ${Off}"
pause_func
dpkg -l | awk '/^ii/{print $2}' | "$_FZF_" -e --prompt="Detail of :>: " --reverse --color=16 --preview="dpkg -s {}"
}	

#-------------#
# EDIT SOURCE #
#-------------#
_EDIT_SOURCE_() {
print_title "Edit Source List "
sleep 2
sudo apt edit-sources
}

#-----------#
# INSTALLED #
#-----------#
_INSTALLED_() {
print_title "List Installed Packages "
sleep 0.5
dpkg -l | awk '/^ii/{print $2}' | less
while true ; do
print_title "List Installed Packages "
echo -e "${BWhite} Do You Want to Save This list ??${BRed} [Y/n] "
echo -en "${BBlue} >: ${Off}"
read save_opt
case "$save_opt" in
    Y|y )
        echo -e "${BBlue} -->${BWhite} Save List Installed Packages ${Off}"
        sleep 1
        dpkg -l | grep "^ii" | awk '{print$2}' > "$HOME"/Documents/List_Installed_Packages.txt
        echo -e " ${BGreen} [${BWhite}Done${BGreen}]${BBlue} -->${BYellow} PATH = ${BPurple}{${BWhite}$HOME/Documents/List_Installed_Packages.txt${BPurple}} ${Off}"
        pause_func
        break
    ;;
    N|n )
            # Nothing to do here
            break
    ;;
    * )
            # There is nothing to do
    ;;
esac
done
}


#-------------#
# INFORMATION #
#-------------#
_INFORMATION_() {
print_title "Package Info "
echo -e "${BBlue} -->${BWhite} Please Maxemize Window For best Preview"
echo -e "${BBlue} -->${BWhite} Press${BYellow} <Esc>${BWhite} To Exit ${Off}"
pause_func
apt-cache pkgnames | sort | "$_FZF_" -e --reverse --prompt="Information About :>: " --color=16 --preview="apt show {}"
}


#--------#
# Search #
#--------#
_SEARCH_() {
    print_title "Search For Packages"
    echo -e "${BBlue} -->${BWhite} Please Maxemize Window For best Preview"
    echo -e "${BBlue} -->${BWhite} Press${BYellow} <Esc>${BWhite} To Exit ${Off}"
    pause_func
    apt-cache pkgnames | sort | "$_FZF_" -e --prompt="Search About :>: " --reverse --color=16
}

#--------------#
# Dist upgarde #
#--------------#
_DIST_UPGRADE_() {
print_title "Upgrade + dist-Upgrade "
    if [ "$(apt list --upgradable)" = "Listing... Done" ];then
            echo -e "${BBlue} -->${BWhite} There No Package To Upgrade ${Off}"
    else
        apt list --upgradable
        print_line
        while true ; do
        echo -e "${BWhite} Do You Want to Upgrade Packages ??${BRed} [Y/n] "
        echo -en "${BBlue} >: ${Off}"
        read upgrade_opt
        case "$upgrade_opt" in
            Y|y )
                    print_title "Upgrade + Dist-Upgrade "
                    sudo apt dist-upgrade
                    break
            ;;
            N|n )
                    # Nothing to do here
                    break
            ;;
            * )
                    # There is nothing to do
            ;;
        esac
        done
    fi
pause_func
}

#--------------#
# Icons Themes #
#--------------#
Icon_Theme () {
while true ; do
	print_title " Icons And Themes PPA's "
echo -e "┌─────────────────────────────────────────────────────────────────────┐"
echo -e "| $(Check_PPA "ppa:numix/ppa")${BGreen} 1 :${BWhite} Numix PPA                  $(Check_PPA "ppa:noobslab/icons")${BCyan} 2 :${BWhite} Noobslab Icons PPA      ${Off} |"
echo -e "| $(Check_PPA "ppa:noobslab/themes")${BBlue} 3 :${BWhite} Noobslab Themes PPa        $(Check_PPA "ppa:noobslab/icons2")${BPurple} 4 :${BWhite} Noobslab Icons2 PPA     ${Off} |"
echo -e "| $(Check_PPA "ppa:noobslab/nitrux-os")${BYellow} 5 :${BWhite} Noobslab Nitrux Icon       $(Check_PPA "ppa:noobslab/potenza")${BGreen} 6 :${BWhite} Noobslab potenza Icon   ${Off} |"
echo -e "| $(Check_PPA "ppa:noobslab/malys-themes")${BPurple} 7 :${BWhite} Noobslab Malys Themes      $(Check_PPA "ppa:noobslab/swar-themes")${BYellow} 8 :${BWhite} Noobslab Swar themes    ${Off} |"
echo -e "├─────────────────────────────────────────────────────────────────────┤"
echo -e "|                            ${BRed} B :${BWhite} Back                               ${Off} |"
echo -e "└─────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}  "
echo -en " ${BBlue} >:${Off} "
read ppa_opt
[ "$ppa_opt" = "b" -o "$ppa_opt" = "B" ] && break
	for po in $ppa_opt ; do
		case "$po" in
			1 )
				PPA_Func "ppa:numix/ppa" "yes"
			;;
			2 )
				PPA_Func "ppa:noobslab/icons" "yes"
			;;
			3 )
				PPA_Func "ppa:noobslab/themes" "yes"
			;;
			4 )
				PPA_Func "ppa:noobslab/icons2" "yes"
			;;
			5 )
				PPA_Func "ppa:noobslab/nitrux-os" "yes"
			;;
			6 )
				PPA_Func "ppa:noobslab/potenza" "yes"
			;;
			7 )
				PPA_Func "ppa:noobslab/malys-themes" "yes"
			;;
			8 )
				PPA_Func "ppa:noobslab/swar-themes" "yes"
			;;
			* )
				# Nothing to do here
			;;
		esac
	done
done
}

#------------------#
# Accessories Apps #
#------------------#
Access_Apps () {
while true ; do
	print_title " Accessories Applications "
echo -e "┌─────────────────────────────────────────────────────────────────────┐"
echo -e "|   $(Check "catfish")${BGreen} 1 :${BWhite} CatFish      $(Check "terminix")${BYellow} 2 : ${BWhite}Terminix        $(Check "plank")${BPurple} 3 : ${BWhite}Plank        ${Off}|"
echo -e "|   $(Check "galculator")${BYellow} 4 :${BWhite} Galculator   $(Check "pyrenamer")${BCyan} 5 : ${BWhite}Pyrenamer       $(Check "shutter")${BGreen} 6 : ${BWhite}Shutter      ${Off}|"
echo -e "|   $(Check "hotshots")${BPurple} 7 :${BWhite} Hotshots     $(Check "synapse")${BBlue} 8 : ${BWhite}Synapse         $(Check "terminator")${BBlue} 9 : ${BWhite}Terminator   ${Off}|"
echo -e "├─────────────────────────────────────────────────────────────────────┤"
echo -e "|                            ${BRed} B :${BWhite} Back                               ${Off} |"
echo -e "└─────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}  "
echo -en " ${BBlue} >:${Off} "
read acces_opt
[ "$acces_opt" = "b" -o "$acces_opt" = "B" ] && break
	for AO in $acces_opt ; do
		case "$AO" in
			1 )
				Install_Func "catfish"
			;;
			2 )
				# Terminix 
				PPA_Func "ppa:webupd8team/terminix" "yes"
				Install_Func "terminix"
			;;
			3 )
				Install_Func "plank"
			;;
			4 )
				Install_Func "galculator"
			;;
			5 )
				Install_Func "pyrenamer"
			;;
			6 )
				PPA_Func "ppa:shutter/ppa" "yes"
				Install_Func "shutter"
			;;
			7 )
				PPA_Func "ppa:dhor/myway" "yes"
				Install_Func "hostshots"
			;;
			8 )
				Install_Func "synapse"
			;;
			9 )
				Install_Func "Terminator"
			;;
			* )
				# There is Nothing to do
			;;
		esac
	done
done
}

#------------------#
# Development Apps #
#------------------#
Dev_apps () {
while true ;do
	print_title "Development Applications"
echo -e "┌──────────────────────────────────────────────────────────────────────┐"
echo -e "| $(Check "atom")${BGreen}  1 :${BWhite} Atom        $(Check "emacs")${BPurple}  2 :${BWhite} Emacs            $(Check "vim-gtk")${BBlue}  3 :${BWhite} Gvim         ${Off}|"
echo -e "| $(Check "meld")${BBlue}  4 :${BWhite} Meld        $(Check "android-studio")${BYellow}  5 :${BWhite} Android Studio   $(Check "monodevelop")${BCyan}  6 :${BWhite} Monodevelop  ${Off}|"
echo -e "| $(Check "qtcreator")${BPurple}  7 :${BWhite} QT Creator  $(Check "myqsl-workbench")${BGreen}  8 :${BWhite} MySQL Workbench  $(Check "oracle-java9-installer")${BYellow}  9 :${BWhite} OracleJDK 8  ${Off}|"
echo -e "| $(Check "nodejs")${BYellow} 10 :${BWhite} NodeJS      $(Check "sublime-text-installer")${BCyan} 11 :${BWhite} Sunblime Text    $(Check "bluefish")${BGreen} 12 :${BWhite} Bluefish     ${Off}|"
echo -e "├──────────────────────────────────────────────────────────────────────┤"
echo -e "|                           ${BRed} B :${BWhite} Back                                  ${Off}|"
echo -e "└──────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}  "
echo -en " ${BBlue} >:${Off} "
read Dev_Opt
[ "$Dev_Opt" = "b" -o "$Dev_Opt" = "B" ] && break
	for Do in $Dev_Opt ; do
		case "$Do" in
			1 )
				PPA_Func "ppa:webupd8team/atom" "yes"
            	Install_Func "atom"
			;;
			2 )
				Install_Func "emacs"
			;;
			3 )
				Install_Func "vim-gtk"
			;;
			4 )
				Install_Func "meld"
			;;
			5 )
				PPA_Func "ppa:paolorotolo/android-studio" "yes"
				Install_Func "android-studio"
			;;
			6 )
				Install_Func "monodevelop"
			;;
			7 )
				Install_Func "qtcreator"
			;;
			8 )
				Install_Func "mysql-workbench"
			;;
			9 )
				PPA_Func "ppa:webupd8team/java" "yes"
				Install_Func "oracle-java9-installer"
			;;
			10 )
				Install_Func "nodejs"
			;;
			11 )
				PPA_Func "ppa:webupd8team/sublime-text-3" "yes"
				Install_Func "sublime-text-installer"
			;;
			12 )
				Install_Func "bluefish"
			;;
			* )
				# There is Nothing to do
			;;
		esac
	done
done
}

#-------------#
# Office Apps #
#-------------#
Office_Apps () {
while true ; do
	print_title "Office Applications"
echo -e "┌────────────────────────────────────────────────────────────────────────┐"
echo -e "| $(Check "gnumeric")${BGreen} 1 :${BWhite} Abiword+Gnumeric  $(Check "calligra")${BBlue} 2 :${BWhite} Abiword+Calligra $(Check "calibre")${BRed} 3 :${BWhite} Calibre     ${Off}|"
echo -e "| $(Check "gcstar")${BYellow} 4 :${BWhite} GCStar            $(Check "homebank")${BCyan} 5 :${BWhite} Homebank         $(Check "impressive")${BYellow} 6 :${BWhite} Impressive  ${Off}|"
echo -e "| $(Check "libreoffice")${BPurple} 7 :${BWhite} LibreOffice       $(Check "wps-office")${BGreen} 8 :${BWhite} wpsOffice        $(Check "ocrfeeder")${BPurple} 9 :${BWhite} OCRFeeder   ${Off}|"
echo -e "├────────────────────────────────────────────────────────────────────────┤"
echo -e "|                                 ${BRed} B :${BWhite} Back                              ${Off}|"
echo -e "└────────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}  "
echo -en " ${BBlue} >:${Off} "
read Off_opt
[ "$Off_opt" = "b" -o "$Off_opt" = "B" ] && break
	for oo in $Off_opt ; do
	    case "$oo" in
		1 )
			Install_Func "abiword" "gnumeric"
		;;
		2 )
			Install_Func "abiword" "calligra"
		;;
		3 )
			Install_Func "calibre"
		;;
		4 )
			Install_Func "gcstar"
		;;
		5 )
			Install_Func "homebank"
		;;
		6 )
			Install_Func "impressive"
		;;
		7 )
			Install_Func "libreoffice"
		;;
		8 )
			print_title " WPS Office Installation "
			echo -e "\t${BGreen} ==> :${BWhite} Download Deb Package ${Off}"
			wget -O "$HOME"/Downloads/Wps-office.deb http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_10.1.0.6757_amd64.deb
			print_line
			if [ -e "$HOME/Downloads/Wps-office_10.deb" ];then
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				sudo dpkg -i "$HOME"/Downloads/Wps-office.deb
				sudo apt-get install -f
				pause_func
			else
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				echo -e " ${BGreen} ==> :${BWhite} There is a Error the link is not valid or u have a bad connection ${Off}"
			fi
				
		;;
		9 )
			Install_Func "ocrfeeder"
		;;
		* )
			# There is Nothing to do
		;;
		esac
	done
done
}

#-------------#
# System Apps #
#-------------#
Sys_Apps () {
while true ; do
	print_title "System Applications"
echo -e "┌──────────────────────────────────────────────────────────────────────────┐"
echo -e "|  $(Check "clamav")${BRed}  1 :${BWhite} ClamAV      $(Check "firewalld")${BPurple}  2 :${BWhite} FirewallD       $(Check "gparted")${BRed}  3 :${BWhite} Gparted          ${Off}|"
echo -e "|  $(Check "grsync")${BBlue}  4 :${BWhite} Grsync      $(Check "ubuntu-cleaner")${BGreen}  5 :${BWhite} Ubuntu Cleaner  $(Check "gufw")${BYellow}  6 :${BWhite} GUFW             ${Off}|"
echo -e "|  $(Check "virtualbox")${BGreen}  7 :${BWhite} VirtualBox  $(Check "wine")${BCyan}  8 :${BWhite} Wine            $(Check "docker")${BPurple}  9 :${BWhite} Docker           ${Off}|"
echo -e "|  $(Check "synaptic")${BPurple} 10 :${BWhite} Synaptic    $(Check "mintstick")${BYellow} 11 :${BWhite} Mint Stick      $(Check "grub-customizer")${BGreen} 12 :${BWhite} Grub Customizer  ${Off}|"
echo -e "├──────────────────────────────────────────────────────────────────────────┤"
echo -e "|                                 ${BRed} B :${BWhite} Back                               ${Off} |"
echo -e "└──────────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}  "
echo -en " ${BBlue} >:${Off} "
read Sys_opt
[ "$Sys_opt" = "b" -o "$Sys_opt" = "B" ] && break
for so in $Sys_opt ;do
	case "$so" in
		1 )
			Install_Func "clamav"
		;;
		2 )
			Install_Func "firewalld"
		;;
		3 )
			Install_Func "gparted"
		;;
		4 )
			Install_Func "grsync"
		;;
		5 )
			PPA_Func "ppa:gerardpuig/ppa" "yes"
			Install_Func "ubuntu-cleaner"
		;;
		6 )
			Install_Func "gufw"
		;;
		7 )
			Install_Func "virtualbox"
		;;
		8 )
			Install_Func "wine"
		;;
		9 )
			Install_Func "docker"
		;;
		10 )
			Install_Func "synaptic"
		;;
		11 )
			print_title " Mint Stick Installation "
			echo -e "\t${BGreen} ==> :${BWhite} Download Deb Package ${Off}"
			wget -O "$HOME"/Downloads/mintstick_all.deb http://packages.linuxmint.com/pool/main/m/mintstick/mintstick_1.3.9_all.deb
			print_line
			if [ -e "$HOME/Downloads/mintstick_1.3.1_all.deb" ];then 
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				sudo dpkg -i "$HOME"/Downloads/mintstick_all.deb
				sudo apt install -f
				sudo apt install python-gi 
				pause_func
			else
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				echo -e " ${BGreen} ==> :${BWhite} There is a Error the link is not valid or you have a bad connection ${Off}"
			fi
		;;
		12 )
			PPA_Func "ppa:danielrichter2007/grub-customizer" "yes"
			Install_Func "grub-customizer"
		;;
		* )
			# There is Nothing to do
		;;
	esac
done
done
}

#---------------#
# Graphics Apps #
#---------------#
Graph_Apps () {
while true ; do
	print_title "Graphics Applications"
echo -e "┌─────────────────────────────────────────────────────────────────────┐"
echo -e "|   $(Check "blender")${BGreen} 1 :${BWhite} Blender    $(Check "gimp")${BPurple} 2 :${BWhite} Gimp       $(Check "ghtumb")${BBlue} 3 :${BWhite} Gthumb              ${Off}|"
echo -e "|   $(Check "inkscape")${BYellow} 4 :${BWhite} Inkscape   $(Check "mcomix")${BCyan} 5 :${BWhite} MComix     $(Check "pencil")${BYellow} 6 :${BWhite} Pencil              ${Off}|"
echo -e "|   $(Check "scribus")${BBlue} 7 :${BWhite} Scribus    $(Check "shotwell")${BGreen} 8 :${BWhite} Shotwell   $(Check "simple-scan")${BPurple} 9 :${BWhite} Simple Scan         ${Off}|"
echo -e "├─────────────────────────────────────────────────────────────────────┤"
echo -e "|                            ${BRed} B :${BWhite} Back                               ${Off} |"
echo -e "└─────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}  "
echo -en " ${BBlue} >:${Off} "
read Graph_opt
[ "$Graph_opt" = "b" -o "$Graph_opt" = "B" ] && break
for go in $Graph_opt ;do
	case "$go" in
		1 )
			Install_Func "blender"
		;;
		2 )
			Install_Func "gimp" "gimp-data"
		;;
		3 )
			Install_Func "gthumb"
		;;
		4 )
			Install_Func "inkscape"
		;;
		5 )
			Install_Func "mcomix"
		;;
		6 )
			Install_Func "pencil"
		;;
		7 )
			Install_Func "scribus"
		;;
		8 )
			Install_Func "shotwell"
		;;
		9 )
			Install_Func "simple-scan"
		;;
		* )
			# There is Nothing to do
		;;
	esac
done
done
}

#---------------#
# Internet Apps #
#---------------#
Internet_Apps () {
while true ; do
	print_title "Internet Applications"
echo -e "┌───────────────────────────────────────────────────────────────────────────┐"
echo -e "|  $(Check "google-chrome")${BGreen}  1 :${BWhite} Google Chrome  $(Check "chromium-browser")${BPurple}  2 :${BWhite} Chromium        $(Check "firefox")${BGreen}  3 :${BWhite} Firefox        ${Off}|"
echo -e "|  $(Check "midori")${BBlue}  4 :${BWhite} Midori         $(Check "opera")${BCyan}  5 :${BWhite} Opera stable    $(Check "deluge")${BBlue}  6 :${BWhite} Deluge         ${Off}|"
echo -e "|  $(Check "dropbox")${BYellow}  7 :${BWhite} Dropbox        $(Check "qbittorrent")${BGreen}  8 :${BWhite} qBittorrent     $(Check "sparkleshare")${BCyan}  9 :${BWhite} Sparkleshare   ${Off}|"
echo -e "|  $(Check "transmission")${BPurple} 10 :${BWhite} Transmission   $(Check "uget")${BBlue} 11 :${BWhite} uGet            $(Check "liferea")${BYellow} 12 :${BWhite} Liferea        ${Off}|"
echo -e "|  $(Check "thunderbird")${BCyan} 13 :${BWhite} Thunderbird    $(Check "vivaldi")${BCyan} 14 :${BWhite} Vivaldi Browser $(Check "hexchat")${BPurple} 15 :${BWhite} HexChat        ${Off}|"
echo -e "|  $(Check "irssi")${BGreen} 16 :${BWhite} Irssi          $(Check "pidgin")${BPurple} 17 :${BWhite} Pidgin          $(Check "megasync")${BCyan} 18 :${BWhite} MEGAsync       ${Off}|"
echo -e "|  $(Check "googleearth-package")${BYellow} 19 :${BWhite} Google Earth   $(Check "remina")${BBlue} 20 :${BWhite} Remmina         $(Check "teamviewer")${BGreen} 21 :${BWhite} Teamviewer     ${Off}|"
echo -e "├───────────────────────────────────────────────────────────────────────────┤"
echo -e "|                              ${BRed} B :${BWhite} Back                                   ${Off} |"
echo -e "└───────────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}  "
echo -en " ${BBlue} >:${Off} "
read Int_opt
[ "$Int_opt" = "b" -o "$Int_opt" = "B" ] && break
for so in $Int_opt ;do
	case "$so" in
		1 )
			print_title " Google Chrome Installation "
			echo -e "\t${BGreen} ==> :${BWhite} Download Deb Package ${Off}"
			wget -O "$HOME"/Downloads/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
			print_line
			if [ -e "$HOME/Downloads/google-chrome-stable_current_amd64.deb" ];then 
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				sudo dpkg -i "$HOME"/Downloads/google-chrome-stable_current_amd64.deb
				sudo apt install -fy
				pause_func
			else
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				echo -e " ${BGreen} ==> :${BWhite} There is a Error the link is not valid or you have a bad connection ${Off}"
			fi
		;;
		2 )
			Install_Func "chromium-browser"
		;;
		3 )
			Install_Func "firefox"
		;;
		4 )
			Install_Func "midori"
		;;
		5 )
			print_title " Opera Installation "
			echo -e "\t${BGreen} ==> :${BWhite} Download Deb Package ${Off}"
			wget -O "$HOME"/Downloads/opera-stable_amd64.deb http://download1.operacdn.com/pub/opera/desktop/47.0.2631.80/linux/opera-stable_57.0.3098.106_amd64.deb
			print_line
			if [ -e "$HOME/Downloads/opera-stable_47.0.2631.80_amd64.deb" ];then 
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				sudo dpkg -i "$HOME"/Downloads/opera-stable_amd64.deb 
				sudo apt install -fy
				pause_func
			else
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				echo -e " ${BGreen} ==> :${BWhite} There is a Error the link is not valid or you have a bad connection ${Off}"
			fi
		;;
		6 )
			Install_Func "deluge"
		;;
		7 )
			Install_Func "dropbox"
		;;
		8 )
			Install_Func "qbittorrent"
		;;
		9 )
			Install_Func "sparkleshare"
		;;
		10 )
			Install_Func "transmission-gtk"
		;;
		11 )
			Install_Func "uget"
		;;
		12 )
			Install_Func "liferea"
		;;
		13 )
			Install_Func "thunderbird"
		;;
		14 )
			print_title " Vivaldi Installation "
			echo -e "\t${BGreen} ==> :${BWhite} Download Deb Package ${Off}"
			wget -O "$HOME"/Downloads/vivaldi-stable_1.7.735.46-1_amd64.deb https://downloads.vivaldi.com/stable/vivaldi-stable_1.7.735.46-1_amd64.deb
			print_line
			if [ -e "$HOME/Downloads/vivaldi-stable_1.7.735.46-1_amd64.deb" ];then 
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				sudo dpkg -i "$HOME"/Downloads/vivaldi-stable_1.7.735.46-1_amd64.deb
				sudo apt install -fy
				pause_func
			else
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				echo -e " ${BGreen} ==> :${BWhite} There is a Error the link is not valid or you have a bad connection ${Off}"
			fi
		;;
		15 )
			Install_Func "hexChat"
		;;
		16 )
			Install_Func "irssi"
		;;
		17 )
			Install_Func "pidgin"
		;;
		18 )
			print_title " Megasync Installation "
			echo -e "\t${BGreen} ==> :${BWhite} Download Deb Package ${Off}"
			wget -O "$HOME"/Downloads/Megasync.deb https://mega.nz/linux/MEGAsync/xUbuntu_16.04/amd64/megasync-xUbuntu_16.04_amd64.deb
			print_line
			if [ -e "$HOME/Downloads/Megasync.deb" ];then 
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				sudo dpkg -i "$HOME"/Downloads/Megasync.deb
				sudo apt install -fy
				pause_func
			else
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				echo -e " ${BGreen} ==> :${BWhite} There is a Error the link is not valid or you have a bad connection ${Off}"
			fi
		;;
		19 )
			Install_Func "googleearth-package"
		;;
		20 )
			Install_Func "remmina"
		;;
		21 )
			print_title " Teamviewer Installation "
			echo -e "\t${BGreen} ==> :${BWhite} Download Deb Package ${Off}"
			wget -O "$HOME"/Downloads/teamviewer_amd64.deb http://download.teamviewer.com/download/teamviewer_amd64.deb
			print_line
			if [ -e "$HOME/Downloads/teamviewer_amd64.deb" ];then 
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				sudo dpkg -i "$HOME"/Downloads/teamviewer_amd64.deb
				sudo apt install -fy
				pause_func
			else
				echo -e "\t${BGreen} ==> :${BWhite} Install Deb Package ${Off}"
				echo -e " ${BGreen} ==> :${BWhite} There is a Error the link is not valid or you have a bad connection ${Off}"
			fi
		;;
		* )
			# There is Nothing to do
		;;
	esac
done
done
}

#------------#
# Audio Apps #
#------------#
Audio_Apps () {
while true ; do
	print_title "Audio Applications"
echo -e "┌─────────────────────────────────────────────────────────────────────┐"
echo -e "|   $(Check "amarok")${BGreen}  1 :${BWhite} Amarok       $(Check "audacious")${BCyan}  2 :${BWhite} Audacious   $(Check "banshee")${BYellow}  3 :${BWhite} Banshee       ${Off}|"
echo -e "|   $(Check "clementine")${BBlue}  4 :${BWhite} Clementine   $(Check "musique")${BPurple}  5 :${BWhite} Musique     $(Check "radiotray")${BCyan}  6 :${BWhite} Radiotray     ${Off}|"
echo -e "|   $(Check "rhythmbox")${BYellow}  7 :${BWhite} Rhythmbox    $(Check "timidity")${BGreen}  8 :${BWhite} Timidity    $(Check "tomahawk")${BPurple}  9 :${BWhite} Tomahawk      ${Off}|"
echo -e "|   $(Check "quodlibet")${BPurple} 10 :${BWhite} Quodlibet    $(Check "audacity")${BBlue} 11 :${BWhite} Audacity    $(Check "easytag")${BBlue} 12 :${BWhite} Easytag       ${Off}|"
echo -e "├─────────────────────────────────────────────────────────────────────┤"
echo -e "|                 ${BRed} B :${BWhite} Back              ${BBlue} C :${BWhite} Codecs                 ${Off} |"
echo -e "└─────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}  "
echo -en " ${BBlue} >:${Off} "
read Audio_opt
[ "$Audio_opt" = "b" -o "$Audio_opt" = "B" ] && break
for ao in $Audio_opt ;do
	case "$ao" in
		1 )
			Install_Func "amarok"
		;;
		2 )
			Install_Func "audacious"
		;;
		3 )
			Install_Func "banshee"
		;;
		4 )
			Install_Func "clementine"
		;;
		5 )
			Install_Func "musique"
		;;
		6 )
			Install_Func "radiotray"
		;;
		7 )
			Install_Func "rhythmbox"
		;;
		8 )
			Install_Func "timidity"
		;;
		9 )
			Install_Func "tomahawk"
		;;
		10 )
			Install_Func "quodlibet"
		;;
		11 )
			Install_Func "audacity"
		;;
		12 )
			Install_Func "easytag"
		;;
		C|c )
			Install_Func "ubuntu-restricted-extras"
		;;
		* )
			# There is Nothing to do
		;;
	esac
done
done
}

#------------#
# Video Apps #
#------------#
video_Apps () {
while true ; do
	print_title "Video Applications"
echo -e "┌─────────────────────────────────────────────────────────────────────┐"
echo -e "|  $(Check "gnome-mplayer")${BGreen}  1 :${BWhite} Gnome MPlayer  $(Check "minitube")${BCyan}  2 :${BWhite} Minitube  $(Check "livestreamer")${BGreen}  3 :${BWhite} LiveStreamer   ${Off}|"
echo -e "|  $(Check "mpv")${BYellow}  4 :${BWhite} MPV            $(Check "parole")${BPurple}  5 :${BWhite} Parole    $(Check "vlc")${BBlue}  6 :${BWhite} VLC            ${Off}|"
echo -e "|  $(Check "kodi")${BBlue}  7 :${BWhite} Kodi           $(Check "arista")${BGreen}  8 :${BWhite} Arista    $(Check "avidemux")${BCyan}  9 :${BWhite} Avidemux       ${Off}|"
echo -e "|  $(Check "handbrake")${BPurple} 10 :${BWhite} Handbrake      $(Check "kazam")${BBlue} 11 :${BWhite} Kazam     $(Check "kdenlive")${BYellow} 12 :${BWhite} Kdenlive       ${Off}|"
echo -e "|  $(Check "openshot")${BCyan} 13 :${BWhite} Openshot       $(Check "pitivi")${BYellow} 14 :${BWhite} Pitivi    $(Check "transmageddon")${BPurple} 15 :${BWhite} Transmageddon  ${Off}|"
echo -e "|  $(Check "simplescreenrecorder")${BGreen} 16 :${BWhite} Simple Screen Recorder            $(Check "obs-studio")${BCyan} 17 :${BWhite} OBS studio     ${Off}|"
echo -e "├─────────────────────────────────────────────────────────────────────┤"
echo -e "|                 ${BRed} B :${BWhite} Back              ${BBlue} C :${BWhite} Codecs                 ${Off} |"
echo -e "└─────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}"
echo -en " ${BBlue} >:${Off} "
read Vid_opt
[ "$Vid_opt" = "b" -o "$Vid_opt" = "B" ] && break
for vo in $Vid_opt ; do
	case "$vo" in
		1 )
			Install_Func "gnome-mplayer"
		;;
		2 )
			Install_Func "minitube"
		;;
		3 )
			Install_Func "livestreamer"
		;;
		4 )
			Install_Func "mpv"
		;;
		5 )
			Install_Func "parole"
		;;
		6 )
			Install_Func "vlc"
		;;
		7 )
			Install_Func "kodi"
		;;
		8 )
			Install_Func "arista"
		;;
		9 )
			Install_Func "avidemux"
		;;
		10 )
			Install_Func "handbrake"
		;;
		11 )
			Install_Func "kazam"
		;;
		12 )
			Install_Func "kdenlive"
		;;
		13 )
			Install_Func "openshot"
		;;
		14 )
			Install_Func "pitivi"
		;;
		15 )
			Install_Func "transmageddon"
		;;
		16 )
		    PPA_Func "ppa:maarten-baert/simplescreenrecorder" "yes"
		    Install_Func "simplescreenrecorder"
		;;
		17 )
		    PPA_Func "ppa:obsproject/obs-studio" "yes"
		    Install_Func "obs-studio"
		;;
		C|c )
			Install_Func "ubuntu-restricted-extras"
		;;
		* )
			# There is Nothing to do
		;;
	esac
done
done
}

#--------------------#
# Desktop Evironment #
#--------------------#
Desktop_Evi () {
while true ; do
	print_title " Desktop Evironment"
echo -e "┌─────────────────────────────────────────────────────────────────────┐"
echo -e "|      $(Check "xfwm4")${BGreen}  1 :${BWhite} XFCE4 Mini                $(Check "xfce4-goodies")${BCyan}  2 :${BWhite} XFCE4 Full         ${Off}|"
echo -e "|      $(Check "lxde-core")${BYellow}  3 :${BWhite} LXDE Mini                 $(Check "lxde")${BPurple}  4 :${BWhite} LXDE Full          ${Off}|"
echo -e "|      $(Check "gnome-shell")${BBlue}  5 :${BWhite} Gnome Shell               $(Check "cinnamon")${BGreen}  6 :${BWhite} Cinnamon           ${Off}|"
echo -e "|      $(Check "plasma-desktop")${BPurple}  7 :${BWhite} KDE Plasma                $(Check "mate-desktop-environment")${BBlue}  8 :${BWhite} MATE               ${Off}|"
echo -e "├─────────────────────────────────────────────────────────────────────┤"
echo -e "|                            ${BRed} B :${BWhite} Back                               ${Off} |"
echo -e "└─────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}"
echo -en " ${BBlue} >:${Off} "
read Desk_opt
[ "$Desk_opt" = "b" -o "$desk_opt" = "B" ] && break
for Do in $Desk_opt ; do
	case "$Do" in
		1 )
			Install_Func "xfce4" "xfce4-terminal"
		;;
		2 )
			Install_Func "xfce4" "xfce4-goodies"
		;;
		3 )
			Install_Func "lxde-core" "lxsession-logout"
		;;
		4 )
			Install_Func "lxde"
		;;
		7 )
			Install_Func "plasma-desktop"
		;;
		5 )
			Install_Func "gnome"
		;;
		6 )
			Install_Func "cinnamon"
		;;
		8 )
			Install_Func "mate-desktop-environment" "mate-desktop-environment-extras"
		;;
		* )
			# There is Nothing to do
		;;
	esac
done
done
}

#----------------#
# Window Manager #
#----------------#
Window_M () {
while true ; do
	print_title " Window Manager "
echo -e "┌─────────────────────────────────────────────────────────────────────┐"
echo -e "|      $(Check "openbox")${BGreen}  1 :${BWhite} Openbox                  $(Check "fluxbox")${BCyan}  2 :${BWhite} Fluxbox             ${Off}|"
echo -e "|      $(Check "enlightenment")${BYellow}  3 :${BWhite} Elightenment             $(Check "icewm")${BPurple}  4 :${BWhite} IceWM               ${Off}|"
echo -e "|      $(Check "blackbox")${BBlue}  5 :${BWhite} BlackBox                 $(Check "pekwm")${BGreen}  6 :${BWhite} PekWM               ${Off}|"
echo -e "|      $(Check "i3")${BPurple}  7 :${BWhite} i3 WM                    $(Check "awesome")${BBlue}  8 :${BWhite} Awesome WM          ${Off}|"
echo -e "├─────────────────────────────────────────────────────────────────────┤"
echo -e "|                            ${BRed} B :${BWhite} Back                               ${Off} |"
echo -e "└─────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}"
echo -en " ${BBlue} >:${Off} "
read WM_opt
[ "$WM_opt" = "b" -o "$WM_opt" = "B" ] && break
for Wo in $WM_opt ; do
	case "$Wo" in
		1 )
			Install_Func "openbox" "obmenu"
		;;
		2 )
			Install_Func "fluxbox"
		;;
		3 )
		    PPA_Func "ppa:niko2040/e19" "yes"
			Install_Func "enlightenment" "rage" "terminology"
		;;
		4 )
			Install_Func "icewm" "icewm-experimental" "icewm-lite" "icewm-themes"
		;;
		7 )
			Install_Func "i3" "i3blocks"
		;;
		5 )
			Install_Func "blackbox" "blackbox-themes"
		;;
		6 )
			Install_Func "pekwm-themes" "pekwm"
		;;
		8 )
			Install_Func "awesome" "awesome-extra"
		;;
		* )
			# There is Nothing to do
		;;
	esac
done
done
}

#------------#
# Extar Apps #
#------------#
Extar_App () {
while true ; do
	print_title " Extra Applications "
echo -e "┌─────────────────────────────────────────────────────────────────────┐"
echo -e "|      $(Check "playonlinux" )${BGreen}  1 :${BWhite} PlayOnLinux             $(Check "blueman")${BCyan}  2 :${BWhite} Bluetooth Manager    ${Off}|"
echo -e "|      $(Check "y-ppa-manager")${BYellow}  3 :${BWhite} Y PPA Manager           $(Check "liferea")${BPurple}  4 :${BWhite} LifeRea              ${Off}|"
echo -e "|      $(Check "keepassx")${BBlue}  5 :${BWhite} KeePassX                $(Check "seahorse")${BGreen}  6 :${BWhite} Seahorse             ${Off}|"
echo -e "|      $(Check "deja-dup")${BPurple}  7 :${BWhite} Deja Dup                $(Check "gtkhash")${BBlue}  8 :${BWhite} GTKHash              ${Off}|"
echo -e "├─────────────────────────────────────────────────────────────────────┤"
echo -e "|                            ${BRed} B :${BWhite} Back                               ${Off} |"
echo -e "└─────────────────────────────────────────────────────────────────────┘"
echo ""
echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off}"
echo -en " ${BBlue} >:${Off} "
read Extra_opt
[ "$Extra_opt" = "b" -o "$Extra_opt" = "B" ] && break
for Eo in $Extra_opt ; do
	case "$Eo" in
		1 )
			Install_Func "playonlinux"
		;;
		2 )
			Install_Func "blueman"
		;;
		3 )
		    PPA_Func "ppa:webupd8team/y-ppa-manager" "yes"
			Install_Func "y-ppa-manager"
		;;
		4 )
			Install_Func "liferea"
		;;
		7 )
			Install_Func "deja-dup"
		;;
		5 )
			Install_Func "keepassx"
		;;
		6 )
			Install_Func "seahorse"
		;;
		8 )
			Install_Func "gtkhash"
		;;
		* )
			# There is Nothing to do
		;;
	esac
done
done
}

#-----------#
# Main Menu #
#-----------#
Main_Menu () {
while true ; do
echo -e "\r ${Off}"
print_title "APT GATE :${BRed} Package Manager Controle "
    echo -e "\t ${BGreen}:: ${BCyan}Some Populer Software ${BGreen}:: ${Off}"
    echo -e "\t ---------------------------"
    echo -e "    ${BCyan} 1 :${BWhite} Icons / Themes    ${BYellow}  2 :${BWhite} Accessories "
    echo -e "    ${BBlue} 3 :${BWhite} Development       ${BGreen}  4 :${BWhite} Office "
    echo -e "    ${BPurple} 5 :${BWhite} System            ${BCyan}  6 :${BWhite} Graphics "
    echo -e "    ${BRed} 7 :${BWhite} Internet          ${BBlue}  8 :${BWhite} Audio "
    echo -e "    ${BGreen} 9 :${BWhite} Video             ${BYellow} 10 :${BWhite} Desktop Environment"
    echo -e "    ${BPurple}11 :${BWhite} Window Manager    ${BRed} 12 :${BWhite} Extras ${Off}"
    print_line
    echo -e "\n\t ${BGreen}:: ${BBlue}Package Manager Tools ${BGreen}:: ${Off}"
    echo -e "\t ---------------------------"
    echo -e "${BGreen}  U  :${BWhite} Update System         ${BRed}Ud :${BWhite} Upgrade + Dist Upgrade  "
    echo -e "${BRed}  S  :${BWhite} Search for Package    ${BBlue}In :${BWhite} Package Info   "
    echo -e "${BBlue}  L  :${BWhite} List Install Packages ${BCyan} D :${BWhite} Detail Installed Packages "
    echo -e "${BCyan}  E  :${BWhite} Edit Source List      ${BGreen}De :${BWhite} Install .Deb Package "
    echo -e "${BGreen}  I  :${BWhite} Install Package       ${BRed} R :${BWhite} Remove Package  "
    echo -e "${BBlue}  A  :${BWhite} Add Repository        ${BCyan}Rr :${BWhite} Remove Repository "
    echo -e "${BRed}  Ro :${BWhite} Remove old App Config ${BGreen}C  :${BWhite} Clean Packages Cache"
    echo -e "${BYellow}  LP :${BWhite} Locate Package ${Off}"
    echo ""
print_line
    echo ""
    echo -e " ${BWhite} Enter ${BRed}N°${BWhite} of options ${BBlue}( EX: 1 2 3 ):${Off} -${BRed} Q${BWhite} Exit${Off}"
    echo -en " ${BBlue} >:${Off} "
    read choix
for i in $choix ; do
	case "$i" in
		1 )
			Icon_Theme
		;;
		2 )
			Access_Apps
		;;
		3 )
			Dev_apps
		;;
		4 )
			Office_Apps
		;;
		5 )
			Sys_Apps
		;;
		6 )
			Graph_Apps
		;;
		7 )
			Internet_Apps
		;;
		8 )
			Audio_Apps
		;;
		9 )
			video_Apps
		;;
		10 )
		    Desktop_Evi
		;;
		11 )
		    Window_M
		;;
		12 )
                    Extar_App
		;;
		RO|Ro|ro|rO )
                    _Remove_old_config_
		;;
		C|c )
                    _Clean_pkg_
		;;
        LP|Lp|lp|lP )
                    _Locale_pkg_
                ;;
		u|U )
                    _Update_system_
		;;
		ud|UD|Ud|uD )
                    _DIST_UPGRADE_
		;;
		S|s )
                    _SEARCH_
		;;
		In|IN|iN|in )
                    _INFORMATION_
		;;
		L|l )
                    _INSTALLED_
		;;
		D|d )
                    _DETAIL_
                ;;
		E|e )
                    _EDIT_SOURCE_
		;;
		I|i )
                    _INSTALL_PKG
		;;
		R|r )
                    _RM_PKG_
		;;
		A|a )
                    _ADD_REPO_
		;;
		Rr|RR|rr|rR )
                    _RM_REPO_
		;;
		DE|De|de|dE )
                    _INS_DEB_
		;;
		q|Q )
			clear && exit
		;;
		* )
			# Nothing to do here
		;;
	esac
done
done
}

trap ' ' 2
Check_Network
Main_Menu
trap - 2 
