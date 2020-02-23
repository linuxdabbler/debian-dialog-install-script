#!/bin/bash

# Borrowed some of the syntax from DasGeek among others...
# Tested on Debian Buster and Testing
# Version 0.1

##  Define Temp location - "dis" stands for "debian-install-script"

tmd_dir=/tmp/dis

##  Define some variables because I'm lazy

install='apt install'
update='apt update; apt upgrade -y'
user=$USER
#User=$(getent passwd 1000 | awk -F: '{ print $1}')

## Start script
cp /etc/apt/sources.list /etc/apt/sources.list.original

if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root type: sudo ./dialog.sh"
        exit 1
else
        #Update and Upgrade
        echo "Updating and Upgrading"
        $update

        echo "Creating temporary folder"
        mkdir $tmp_dir

        $install dialog
        cmd=(dialog --title "LD-Installer" --separate-output --checklist "Please Select Software You Want To Install:" 22 80 16)
        options=(
		#A "<----Category: Repositories---->" on
			1_repos "	Grant Standard User Root Access" off
			2_repos "	Contrib and Non-free Repos" off
#			3_repos "	Testing Repos" off
#			4_repos "	Unstable Repos" off
#			5_repos "	Experimental Repos" off
			6_repos "	Return to Original" off
		#B "<----Category: Alternate Installers---->" on
			1_installer "	Snap Packages" off
			2_installer "	Flatpak" off
			3_installer "	Synaptic" off
			4_installer "	PIP" off
		#C "<----Category: Text Editors---->" on
			1_editor "	Vim" off
			2_editor "	Nano" off
			3_editor "	Geany" off
			4_editor "	emacs" off
			5_editor "	Gedit" off
		#D "<----Category: Phone---->" on
			1_phone "	android" off
			2_phone "	iphone" off
		#E "<----Category: Terminal Programs---->" on
			1_terminal "	Compress/Decompress" off
			2_terminal "	UFW" off
			3_terminal "	Identify hardware" off
			4_terminal "	Python" off
			5_terminal "	Cups" off
			6_terminal "	Youtube-dl" off
			7_terminal "	Htop" off
			8_terminal "	Parted" off
			9_terminal "	Curl" off
			10_terminal "	Wget" off
			11_terminal "	Ranger" off
			12_terminal "	Dmenu" off
			13_terminal "	Rofi" off
			14_terminal "	Build Essential" off
			15_terminal "	SSH" off
			16_terminal "	Urxvt" off
			17_terminal " 	Sakura" off
			18_terminal "	Terminator" off
			19_terminal "	Tilix" off
			20_terminal "	Xterm" off
		#F "<----Category: Terminal Customization---->" on
			1_customize "	Neofetch" off
			2_customize "	Screenfetch" off
			3_customize "	Figlet" off
			4_customize " 	Lolcat" off
			5_customize "	Powerline" off
		#G "<----Category: Email---->" on
			1_email "	Thunderbird" off
			2_email "	Neomutt" off
			3_email "	Geary" off
		#H "<----Category: Web Browsers/Downloaders---->" on
			1_web "	Chromium" off
			2_web "	Google Chrome" off
			3_web "	Vivaldi" off
			4_web "	ICE-SSB-Application" off
			5_web "	Transmission" off
		#I "<----Category: Networking---->" on
			1_network "	SAMBA" off
		#J "<----Category: Graphics---->" on
			1_graphics "	Nvidia Driver" off
			2_graphics "	AMD Driver" off
		#K "<----Category: Sound---->" on
			1_sound "	Pulse Audio" off
			2_sound "	ALSA" off
		#L "<----Category: Fonts---->" on
			1_font "	Microsoft fonts" off
			2_font "	Ubuntu fonts" off
		#M "<----Category: Icons---->" on
			1_icon "	Numix icons" off
			2_icon "	Moka icons" off
			3_icon "	Mate icons" off
			4_icon "	Papirus icons" off
			5_icon "	Deepin-icons" off
		#N "<----Category: Photo Viewing/Editing---->" on
			1_photo "	Feh" off
			2_photo "	Gimp" off
			3_photo "	Inkscape" off
			4_photo "	Digikam" off
			5_photo "	Darktable" off
			6_photo "	Shotwell" off
		#O "<----Category: Media Viewing/Editing/Converting---->" on
			1_media "	Handbrake" off
			2_media "	Kdenlive" off
			3_media "	VLC" off
			4_media "	Audacity" off
			5_media "	Plex Media Server" off
			6_media "	Simple Screen Recorder" off
			7_media "	OBS Studio" off
			8_media "	Optical Drive Software" off
			9_media "	SM Player" off
			10_media "	FFmpeg" off
		#P "<----Category: Gaming---->" on
			1_gaming "	Steam" off
			2_gaming "	Lutris" off
		#Q "<----Category: File Explorer---->" on
			1_files "	Nemo" off
			2_files "	Thunar" off
			3_files "	Pcmanfm" off
			4_files "	Caja" off
			5_files "	Nautilus" off
			6_files "	Dolphin" off
		#R "<----Category: Desktop Customization---->" on
			1_desktop "	nitrogen" off
			2_desktop "	variety" off
			3_desktop "	lxappearance" off
			4_desktop "	conky" off
			5_desktop "	QT matches GTK" off
			6_desktop "	Vimix Theme" off
			7_desktop "	Adapta Theme" off
			8_desktop "	Polybar" off
		#S "<----Category: File Systems---->" on
			1_filesystem "	ZFS" off
			2_filesystem " 	Exfat" off
		#T "<----Category: Virtualizaion---->" on
			1_virtual "	Virtualbox" off
			2_virtual "	Gnome Boxes" off
		#U "<----Category: System---->" on
			1_system "	Swappiness=10" off
			V "Post Install Auto Clean Up & Update" off)
		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
			case $choice in
# Section A -----------------------Repositories----------------------------
		1_repos)
				#  Find the standard user you created during installation and make it a variable
			User=$(getent passwd 1000 |  awk -F: '{ print $1}')
				#  Echo the user into the sudoers file
			echo "$User  ALL=(ALL:ALL)  ALL" >> /etc/sudoers
			sleep 1
			;;
		2_repos)
			#Enable Contrib and Non-free Repos
			echo "enabling Contrib and Non-free Repos"
			cat /etc/apt/sources.list >> /etc/apt/sources.list.bak
			sed -e '/Binary/s/^/#/g' -i /etc/apt/sources.list
			sed -i 's/main/main contrib non-free/gI' /etc/apt/sources.list
			apt update
			sleep 1
			;;
#		3_repos)
#			#Enable Testing Repos
#			echo "enabling Bullseye Repos"
#			#cat /etc/apt/sources.list >> /etc/apt/sources.list.bak
#			#echo "deb http://deb.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list
#			apt update
#			sleep 1
#			;;
#		4_repos)
#			#Enable Unstable Repos
#			echo "enabling Unstable Repos"
#			#cat /etc/apt/sources.list >> /etc/apt/sources.list.bak
#			#echo "deb http://ftp.us.debian.org/debian unstable main contrib non-free" >> /etc/apt/sources.list
#			#echo "deb-src http://ftp.us.debian.org/debain unstable main contrib non-free" >> /etc/apt/sources.list
#			apt update
#			sleep 1
#			;;
#		5_repos)
#			#Enable Experimental Repos
#			cat /etc/apt/sources.list >> /etc/apt/sources.list.bak
#			#echo "deb http://ftp.us.debian.org/debain experimental main contrib non-free" >> /etc/apt/sources.list
#			#echo "deb-src http://ftp.us.debian.org/debian experimental main contrib non-free" >> /etc/apt/sources.list
#			apt update
#			sleep 1
#			;;
		6_repos)
			#Return sources.list to original
			echo "Returning /etc/apt/sources.list to its Original State
			cat /etc/apt/sources.list.original > /etc/apt/sources.list
			apt update
			sleep 1
			;;
			

# Section B ---------------------Alternate Installers----------------------------
		1_installer)
			#Install snap.d
			echo "Installing Snap.d"
			sudo apt install snapd -yy
			sleep 1
			;;

		2_installer)
			#Install flatpak
			echo "installing Flatpak"
			sudo apt install flatpak -yy
			sleep 1
			;;

		3_installer)
			#Install Synaptic
			echo "installing Synaptic"
			sudo apt install synaptic -yy
			sleep 1
			;;

		4_installer)
			#Install PIP
			echo "installing PIP -python installer"
			sudo apt install python-pip python3-pip -yy
			sleep 1
			;;

# Section C ------------------------Text Editors------------------------------

		1_editor)
			#Install Vim
			echo "Installing VIM"
			sudo apt install vim -yy
			sleep 1
			;;

		2_editor)
			#Install Nano
			echo "Installing Nano"
			sudo apt install nano -yy
			sleep 1
			;;

		3_editor)
			#Install Geany
			echo "Installing Geany"
			sudo apt install geany -yy
			sleep 1
			;;

		4_editor)
			#Install Emacs
			echo "Installing Emacs"
			sudo apt install emacs -yy
			sleep 1
			;;

		5_editor)
			#Install Gedit"
			echo "Installing Gedit"
			sudo apt install gedit -yy
			sleep 1
			;;

# Section D ---------------------------Phone------------------------------------

		1_phone)
			#Install Everything for Android Phones
			echo "Installing Android SDK, ADB, Fastboot, and Build Tools"
			sudo apt install android-sdk adb fastboot android-sdk-build-tools android-sdk-common android-sdk-platform-tools -yy
			sleep 1
			;;

		2_phone)
			#Install Everything to do with an iPhone"
			echo "Installing All Packages for iPhone"
			sudo apt install ideviceinstaller libimobiledevice-utils python-imobiledevice libimobiledevice6 libplist3 libplist-utils python-plist ifuse usbmuxd libusbmuxd-tools gvfs-backends gvfs-bin gvfs-fuse -yy
			sudo echo "user_allow-other" >> /etc/fuse.conf
			sudo usermod -aG fuse $User
			sleep 1
			;;

# Section E --------------------------Terminal Programs---------------------------

		1_terminal)
			#Install Compression Programs
			echo "Installing Compression Programs"
			sudo apt install p7zip p7zip-full unrar-free  unrar unrar-free unzip zip -yy
			sleep 1
			;;

		2_terminal)
			#Install Firewall
			echo "Installing UFW"
			sudo apt install ufw gufw -yy
			sleep 1
			;;
	
		3_terminal)
			#Install Hardware Identifier"
			echo "Installing lshw"
			sudo apt install lshw lshw-gtk -yy
			sleep 1
			;;
	
		4_terminal)
			#Install Cups
			echo "Installing CUPS"
			sudo apt install cups cups-pdf -yy
			sleep 1
			;;
	
		5_terminal)
			#Install Youtube-dl
			echo "Installing youtube-dl"
			sudo apt install wget -yy
			sudo wget https://yt-dl.org/latest/youtube-dl -O /usr/local/bin/youtube-dl
			sudo chmod a+x /usr/local/bin/youtube-dl
			hash -r
			sleep 1
			;;
	
		6_terminal)
			#Install Htop"
			echo "Installing Htop"
			sudo apt install htop -yy
			sleep 1
			;;
	
		7_terminal)
			#Install Parted
			echo "Installing Parted and Gparted"
			sudo apt install parted gparted -yy
			sleep 1
			;;
	
		8_terminal)
			#Install Curl
			echo "Installing Curl"
			sudo apt install curl -yy
			sleep 1
			;;
	
		9_terminal)
			#Install Wget
			echo "Installing Wget"
			sudo apt install wget -yy
			sleep 1
			;;
	
		10_terminal)
			#Install Ranger
			echo "Installing Ranger"
			sudo apt install ranger -yy
			sleep 1
			;;
	
		11_terminal)
			#Install Dmenu
			echo "Installing Dmenu"
			sudo apt install dmenu -yy
			sleep 1
			;;
	
		12_terminal)
			#Install Rofi
			echo "Installing Rofi"
			sudo apt install rofi -yy
			sleep 1
			;;
	
		13_terminal)
			#Install Build-Essential
			echo "Installing Build-Essential"
			sudo apt install build-essential cmake -yy
			sleep 1
			;;
	
		14_terminal)
			#Install SSH
			echo "Installing SSH"
			sudo apt install ssh -yy
			sudo systemctl enable ssh
			sudo systemctl start ssh
			sleep 1
			;;
	
		15_terminal)
			#Install Urxvt
			echo "Installing Urxvt"
			sudo apt install rxvt-unicode -yy
			sleep 1
			;;
	
		16_terminal)
			#Install Sakura
			echo "Installing Sakura"
			sudo apt install sakura -yy
			sleep 1
			;;
	
		17_terminal)
			#Install Terminator
			echo "Installing Terminator"
			sudo apt install terminator -yy
			sleep 1
			;;
	
		18_terminal)
			#Install Tilix
			echo "Installing Tilix"
			sudo apt install tilix -yy
			sleep 1
			;;
	
		19_terminal)
			#Install Xterm
			echo "Install XTerm"
			sudo apt install xterm -yy
			sleep 1
			;;

# Section F -------------------------Terminal Customization--------------------------

		1_customize)
			#Install Neofetch
			echo "Installing Neofetch"
			sudo apt install Neofetch -yy
			sleep 1
			;;

		2_customize)
			#Install Screenfetch
			echo "Installing Screenfetch"
			sudo apt install screenfetch -yy
			sleep 1
			;;

		3_customize)
			#Install Figlet
			echo "Installing Figlet"
			sudo apt install figlet -yy
			sleep 1
			;;

		4_customize)
			#Install Lolcat
			echo "Installing lolcat"
			sudo apt install lolcat -yy
			sleep 1
			;;

		5_customize)
			#Install Powerline
			echo "Installing Powerline"
			sudo apt install powerline git -yy
			#Make a powerline font folder
			sudo mkdir /usr/share/fonts/powerline
			# clone powerline fonts from github
			git clone https://github.com/powerline/fonts
			# change directories into fonts folder created by cloning powerline from github
			cd fonts
			# run installation script for powerline fonts
			./install.sh
			# copy powerline fonts into the powerline folder wer created eariler
			sudo cp /home/$USER/.local.share/fonts/*Powerline* /usr/share/fonts/powerline
			#backup the bashrc just to be safe
			sudo cp .bashrc .bashrc.bak
			#enable Powerline Shell
			echo "if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
			    source /usr/share/powerline/bindings/bash/powerline.sh
			fi" >> .bashrc
			# Restart Bash
			. .bashrc
			sleep 1
			;;

# Section G ----------------------------------Terminal Customization------------------------

		1_email)
			#Install Thunderbird
			echo "Installing Thunderbird"
			sudo apt install thunderbird -yy
			sleep 1
			;;

		2_email)
			#Install NeoMutt
			echo "Install NeoMutt"
			sudo apt install neomutt -yy
			sleep 1
			;;

		3_email)
			#Install Geary
			echo "Installing Geary"
			sudo apt install geary -yy
			sleep 1
			;;

# Section H ----------------------------------Web Browsers/Downloaders-------------------------

		1_web)
			#Install Chromium
			echo "Installing Chromium"
			sudo apt install chromium -yy
			sleep 1
			;;

		2_web)
			#Install Google Chrome
			echo "Installing Gooogle Chrome"
			sudo apt install wget -yy
			wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
			sudo dpkg -i google-chome*.deb
			sleep 1
			;;

		3_web)
			#Install Vivaldi
			echo "Installing Vivaldi"
			sudo apt install wget -yy
			wget https://downloads.vivaldi.com/stable/vivaldi-stable_2.1.1337.47-1_amd64.deb
			sudo dpkg -i vivaldi*.deb
			sleep 1
			;;

		4_web)
			#Install ICE-SSB-Application
			echo "Installing ICE-SSB-Application"
			sudo apt install wget -yy
			wget https://launchpad.net/~peppermintos/+archive/ubuntu/ice-dev/+files/ice_6.0.5_all.deb
			sudo dpkg -i ice*.deb
			sleep 1
			;;

		5_web)
			#Install Transmission
			echo "Installing Transmission"
			sudo apt install transmission-gtk -yy
			sleep 1
			;;

# Section I ----------------------------------Networking----------------------------------------------

		1_network)
			#Install Samba
			echo "Installing Samba"
			sudo apt install samba samba-common samba-libs cifs-utils libcups2 cups smbclient gvfs-backends net-tools network-manager network-manager-openvpn network-manager-openvpn-gnome
			#backup smb.conf
			sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
			sudo chmod 755 /etc/samba/smb.conf.bak
			sudo chmod 755 /etc/samba/smb.conf
			sudo grep -v -E "^#|^;" /etc/samba/smb.conf.bak | grep . > /etc/samba/smb.conf
			sudo systemctl enable smbd
			sudo systemctl start smbd
			sudo systemctl enable nmbd
			sudo systemctl start nmbd
			sleep 1
			;;

# Section J -------------------------------Graphics---------------------------------------------------

		1_graphics)
			#Install Nvidia Driver
			echo "Installing Nvidia Driver"
			echo "Make sure you have the contrib and non-free repos enabled and updated"
			sudo apt install nvidia-driver -yy
			sleep 1
			;;

		1_graphics)
			#Install AMD Driver
			echo "Installing AMD firmware for graphics cards"
			sudo apt install firmware-amd-graphics -yy
			sleep 1
			;;

# Section K --------------------------------------Sound----------------------------------------------

		1_sound)
			#Install Pulse Audio
			echo "Installing Pulse Audio"
			sudo apt install pulseaudio pulseaudio-utils pavucontrol pulseaudio-equalizer gstreamer1.0-pulseaudio -yy
			sleep 1
			;;

		2_sound)
			#Install ALSA
			echo "Installing ALSA"
			sudo apt install alsa-utils gstreamser1.0-alsa alsamixergui alsaplayer-gtk alsa-player-daemon alsa-player-common alsa-player-alsa libao-common libao-dbd libao-dev libao4 libasound2 libasound-data libasoundev-libasound-doc libasound-plugins -yy
			sleep 1
			;;

# Section L -------------------------------------Fonts------------------------------------------------

		1_font)
			#Install Microsoft fonts
			echo "Installing Microsoft fonts"
			sudo apt install ttf-mscorefonts-installer -yy
			sleep 1
			;;

		2_font)
			#Install Ubuntu fonts
			echo "Installing Ubuntu fonts"
			# make an ubuntu font folder
			sudo mkdir /usr/share/fonts/truetype/ubuntu-fonts
			# download ubuntu font family
			sudo apt install wget unzip -yy
			wget https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip
			unzip *.zip
			# change directories into unzipped ubuntu folder
			cd ubuntu-font-family*
			# move all ttf fonts into the ubuntu font folder we created eariler
			sudo mv *.ttf /usr/share/fonts/truetype/ubuntu-fonts/
			# change directories back home
			cd ..
			# remove all files dending in ".zip"
			rm *.zip
			# remove all folders beginning with "ubuntu-font-family"
			rm -r ubuntu-font-family*
			sleep 1
			;;

# Section M ---------------------------------Icons---------------------------------------------------

		1_icon)
			#Install Numix Icons
			echo "Installing Numix Icons"
			sudo apt install numix-icon-theme -yy
			sleep 1
			;;

		2_icon)
			#Install Moka Icons
			echo "Installing Moka Icons"
			sudo apt install moka-icon-theme -yy
			sleep 1
			;;

		3_icon)
			#Install Mate Icons
			echo "Installing Mate Icons"
			sudo apt install mate-icon-theme mate-icon-theme-faenza -yy
			sleep 1
			;;

		4_icon)
			#Install Papirus Icons
			echo "Installing Papirus Icons"
			sudo apt install papirus-icon-theme -yy
			sleep 1
			;;

		5_icon)
			#Install Deepin Icons
			echo "Installing Deepin Icons"
			sudo apt install deepin-icon-theme -yy
			sleep 1
			;;

# Section N ---------------------------------Photo Viewing/Editing--------------------------------------

		1_photo)
			#Install Feh
			echo "Installing Feh"
			sudo apt install feh -yy
			sleep 1
			;;

		2_photo)
			#Install Gimp
			echo "Installing Gimp"
			sudo apt install gimp -yy
			sleep 1
			;;

		3_photo)
			#Install Inkscape
			echo "Installing Inkscape"
			sudo apt install inkscape -yy
			sleep 1
			;;

		4_photo)
			#Install Digikam
			echo "Installing Digikam"
			sudo apt install digikam -yy
			sleep 1
			;;

		5_photo)
			#Install Darktable
			echo "Installing Darktable"
			sudo apt install darktable -yy
			sleep 1
			;;

		6_photo)
			#Install Shotwell
			echo "Installing Shotwell"
			sudo apt install shotwell shotwell-common -yy
			sleep 1
			;;

# Section O --------------------------Media Viewing/Editing/Converting---------------------------------

		1_media)
			#Install Handbrake
			echo "Installing Handbrake"
			sudo apt install handbrake -yy
			sleep 1
			;;

		2_media)
			#Install Kdenlive
			echo "Installing Kdenlive"
			sudo apt install kdenlive -yy
			sleep 1
			;;

		3_media)
			#Install VLC
			echo "Installing VLC"
			sudo apt install VLC -yy
			sleep 1
			;;

		4_media)
			#Install Audacity
			echo "Installaing Audacity"
			sudo apt install audacity -yy
			sleep 1
			;;

		5_media)
			#Install Plex Media Server
			echo "Installing Plex Media Server"
			sudo apt install wget -yy
			wget -q https://downloads.plex.tv/plex-media-server-new/1.16.2.1321-ad17d5f9e/debian/plexmediaserver_1.16.2.1321-ad17d5f9e_amd64.deb
			sudo dpkg -i plex*.deb
			sudo systemctl enable plexmediaserver
			sudo systemctl start plexmediaserver
			sleep 1
			;;

		6_media)
			#Install Simple Screen Recorder
			echo "Installing Simple Screen Recorder"
			sudo apt install simplescreenrecorder -yy
			sleep 1
			;;

		7_media)
			#Install OBS Studio
			echo "Installing OBS-Studio"
			sudo apt install obs-studio -yy
			sleep 1
			;;

		8_media)
			#Install Optical Drive Software
			echo "Installing Optical Drive Software"
			sudo apt install k3b asunder -yy
			sudo chmod 4711 /usr/bin/cdrdao
			sudo chmod 4711 /usr/bin/wodim
			sleep 1
			;;

		9_media)
			#Install SM Player
			echo "Installing SMPlayer"
			sudo apt install smplayer smplayer-themes -yy
			sleep 1
			;;

		10_media)
			#Install FFmpeg
			echo "Install FFmpeg"
			sudo apt install ffmpeg -yy
			sleep 1
			;;

# Section P --------------------------------Gaming-------------------------------------------------

		1_gaming)
			#Installing Steam
			ulimit -Hn > ulimit.txt
			# fix permissions for scripting
			sudo chown $USER /etc/apt/sources.list.d
			# add 32bit architecture
			sudo dpkg --add-architecture i386
			# update
			sudo apt update -yy
			# Install vulkan and mesa drivers
			sudo apt install mesa-vulkan-drivers mesa-vulkan-drivers:i386 -yy
			# Install dxvk
			sudo apt install dxvk dxvk-wine32-development dxvk-wine64-development -yy
			# Install Steam
			sudo apt install steam -yy
			# Install game mode
			sudo apt install gamemode -yy
			sleep 1
			;;

		2_gaming)
			#Install Lutris
			echo " Installing Lutris"
			# import wine gpg key
			sudo chown $User /etc/apt/sources.list
			sudo chmod 755 /etc/apt/sources.list
			sudo chown $User /etc/apt/sources.list.d/
			sudo chmod 755 /etc/apt/sources.list.d/
			sudo wget -nc https://dl.winehq.org/wine-builds/winehq.key
			# add wine gpg key
			sudo apt-key add winehq.key
			# add wine repository
			sudo touch /etc/apt/sources.list.d/wine.list
			sudo echo "deb https://dl.winehq.org/wine-builds/debian buster main" > /etc/apt/sources.list.d/wine.list
			# update
			sudo apt update -yy
			# Install wine staging
			sudo apt install --install-recommends winehq-staging -yy
			# Install wine-tricks
			sudo apt install winetricks -yy
			# Install PlayOnLinux
			sudo apt install playonlinux -yy
			# Import lutris repository key
			sudo wget https://download.opensuse.org/repositories/home:/strycore/Debian_9.0/Release.key
			# Add key with apt
			sudo apt-key add Release.key
			# Add Lutris Repository
			sudo touch /etc/apt/sources.list.d/lutris.list
			sudo echo "deb http://download.opensuse.org/repositories/home:/strycore/Debian_9.0/ ./" > /etc/apt/sources.list.d/lutris.list
			$update
			sudo apt install lutris -yy
			# Change Permissions to Root
			sudo chown root:root /etc/apt/sources.list
			sudo chmod 600 /etc/apt/sources.list
			sudo chown root:root /etc/apt/sources.list.d/
			sudo chmod 600 /etc/apt/sources.list.d/
			sleep 1
			;;

# Section Q -----------------------------------File Explorers-----------------------------------------------

		1_files)
			#Install Nemo
			echo "Installing Nemo"
			sudo apt install nemo nemo-python nemo-data nemo-fileroller ffmpegthumbnailer nemo-nextcloud nemo-owncloud -yy
			sleep 1
			;;

		2_files)
			#Install Thunar
			echo "Installing Thunar"
			sudo apt install thunar thunar-data thunar-archive-plugin thunar-media-tags-plugin thunar-vcs-plugin thunar-volman ffmpegthumbnailer -yy
			sleep 1
			;;

		3_files)
			#Install Pcmanfm
			echo "Installing Pcmanfm"
			sudo apt install pcmanfm pcmanfm-qt ffmpegthumbnailer -yy
			sleep 1
			;;

		4_files)
			#Install Caja
			echo "Installing Caja"
			sudo apt install caja caja-common caja-actions caja-actions-common caja-admin caja-extensions-common caja-image-converter caja-open-terminal caja-sendto caja-share caja-wallpaper caja-xattr-tage caja-rename caja-seahorse caja-nextcloud caja-owncloud caja-dropbox ffmpegthumbnailer -yy
			sleep 1
			;;

		5_files)
			#Install Nautilus
			echo "Installing Nautilus"
			sudo apt install nautilus nautilus-data nautilus-admin nautilus-compare nautilus-hide nautilus-scripts-manager nautilus-sendto nautilus-share ffmpegthumbnailer -yy
			sleep 1
			;;

		6_files)
			#Install Dolphin
			echo "Installing Dolphin"
			sudo apt install doplhin dolphin-dev ffmpegthumbnailer -yy
			sleep 1
			;;

# Section R ----------------------------------Desktop Customization---------------------------------------------

		1_desktop)
			#Install nitrogen
			echo "Installing nitrogen"
			sudo apt install nitrogen -yy
			sleep 1
			;;

		2_desktop)
			#Install Variety
			echo "Installing Variety"
			sudo apt install variety -yy
			sleep 1
			;;

		3_desktop)
			#Install LX Appearance
			echo "Installing LXAppearance"
			sudo apt install lxappearance -yy
			sleep 1
			;;

		4_desktop)
			#Install conky
			echo "Installing Conky"
			sudo apt install conky-all
			sleep 1
			;;

		5_desktop)
			#Make qt match gtk
			echo "Make QT match GTK Themes"
			sudo chown $User /etc/environment
			sudo chmod 755 /etc/environment
			sudo echo "QT_QPA_PLATFORMTHEME=gtk2" >> /etc/environment
			sudo chown root:root /etc/environment
			sudo chmod 600 /etc/environment
			sleep 1
			;;

		6_desktop)
			#Install Vimix Theme
			echo "Installing Vimix Theme"
			#Install git
			sudo apt install git -yy
			#Clone the git Repo
			echo "Cloning the Git Repo"
			git clone https://github.com/vinceliuice/vimix-gtk-themes
			cd vimix-gtk-themes
			./Install
			cd ..
			sudo rm -r vimix*
			sleep 1
			;;

		7_desktop)
			#Install Adapta Theme
			echo "Installing Adapta Themes"
			sudo apt install adapta-gtk-theme -yy
			sleep 1
			;;
			
		8_desktop)
			# Install polybar
			echo "installing Dependencies"	
			sudo apt install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev -yy
			sudo apt install libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev -yy
			sudo apt install libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev -yy
			sudo apt install libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev -yy
			sudo apt install libpulse-dev ccache libxcb-composite0 libxcb-composite0-dev -yy
				# Download from polybar from github
			echo "Downloading Polybar form Github"
			git clone https://github.com/jaagr/polybar.git
				# Change directories into polybar
			cd polybar
			echo "Installing Polybar"
			./build.sh
			;;

# Section S -----------------------------------File Systems-------------------------------------------

		1_filesystem)
			#Install ZFS
			echo " Make sure you have the contrib and non-free repos enabled and updated"
			sleep 1
			echo "Installing the headers for your kernel"
			sudo apt install linux-headers-"$(uname -r)" linux-image-amd64 -yy
			echo "Installing the ZFS DKMS and Utilities"
			sudo apt install zfs-dkms zfsutils-linux -yy
			echo "Installing kernel modules"
			sudo modprobe zfs
			echo "Enabling ZFS Services"
			sudo systemctl enable zfs.target
			sudo systemctl enable zfs-import-cache
			sudo systemctl enable zfs-mount
			sudo systemctl enable zfs-import.target
			sudo systemctl enable zfs-import-scan
			sudo systemctl enable zfs-share
			echo "Starting ZFS Services"
			sudo systemctl start zfs.target
			sudo systemctl start zfs-import-cache
			sudo systemctl start zfs-mount
			sudo systemctl start zfs-import.target
			sudo systemctl start zfs-import-scan
			sudo systemctl start zfs-share
			sleep 1
			;;

		2_filesystem)
			#Install Exfat
			echo "Installing Exfat Utilities"
			sudo apt install exfat-utils -yy
			sleep 1
			;;

# Section T ------------------------------------Virtualization------------------------------------------

		1_virtual)
			#Install Virtualbox
			echo "wget is needed... installing"
			sudo apt install wget -yy
			echo "Setting up the Repository"
			wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
			wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
			echo "Adding Repo to Sources.list"
			sudo chown $USER /etc/apt/sources.list.d/ 
			sudo chmod 755 /etc/apt/sources.list.d/
			sudo echo "deb http://download.virtualbox.org/virtualbox/debian bionic contrib" >> /etc/apt/sources.list.d/virtualbox.list
			echo "Running Updates"
			sudo apt update -yy
			echo "Installing Virtualbox"
			sudo apt install virtualbox-6.0 -yy
			echo "Downloading Extension Pack"
			wget -q https://download.virtualbox.org/virtualbox/6.0.10/Oracle_VM_VirtualBox_Extension_Pack-6.0.10.vbox-extpack
			echo "Adding user to the vbox user group"
			sudo usermod -aG vboxusers $User
			sleep 1
			;;

		2_virtual)
			#Install Gnome Boxes
			echo "Installing Gnome Boxes"
			sudo apt install gnome-boxes -yy
			sleep 1
			;;

		V)
			#Cleanup
			echo "Cleaning up"
			sudo apt update -yy
			sudo apt upgrade -yy
			sudo apt autoremove -yy
			rm -rf $tmp_dir
			;;
		esac
	done
fi


