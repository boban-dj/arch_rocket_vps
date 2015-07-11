###################################################################
##                         boya-creations                        ##
##                                                               ##
##                   Copyright (C) 2014 Boban_dj		 		 ##
##                      Use at your own risk!                    ##
##                                                               ##
##  This software released under the GNU General Public License. ##
##																 ##	
###################################################################


# Do not change this unless you want to completely by-pass Arch Linux' way
# of handling Java versions and vendors. Instead, please use script `archlinux-java`
#export JAVA_HOME=/usr/lib/jvm/java-default-runtime

# solution for stdin: is not a tty?? NO
#[ -z "$PS1" ] && return


################################################################################
# APACHE MYSQLD
##apache and mysql start,stop restart
alias on='sudo systemctl start httpd;sudo systemctl start mysqld;'
alias off='sudo systemctl stop httpd;sudo systemctl stop mysqld;'
alias both='sudo systemctl restart httpd;sudo systemctl restart mysqld;'

## carry over aliases in root .bashrc
alias sudo='sudo '



################################################################################
# MEDIA
## ffmpeg screenrec screendec
alias screenrec='ffmpeg -f alsa -ac 2 -i pulse -f x11grab -r 30 -s 1024x768 -i :0.0 -acodec pcm_s16le -vcodec libx264 -preset ultrafast -crf 0 -threads 0 output.mkv'
alias screendec='ffmpeg -i output.mkv -acodec libvorbis -ab 128k -ac 2 -vcodec libx264 -preset slow -crf 22 -threads 0 our-final-product.mp4'

## screenshot with convert
alias screenshot='import -window root my1.png'

## youtube-dl
alias yt_title="youtube-dl --write-description --write-thumbnail -o '%(title)s/%(title)s-%(id)s.%(ext)s'"
alias yt_uploader="youtube-dl --write-description --write-thumbnail -o '%(uploader)s/%(title)s-%(id)s.%(ext)s'"



################################################################################
# SSH
## ssh connect with boya-creations.nl
alias boya='ssh -p 4000 boyacr1q@boya-creations.nl'

################################################################################
# FILESYSTEM
## see permissions in numbers
alias lso="ls -alG | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print}'"

##alias misc
alias hist='history | grep'         # requires an argument

##alias folders-files
alias lsdirs="ls -d -1 $PWD/**"
alias lsfiles="ls -d -1 $PWD/*.*"

##current dirsize,sort by size low-high, show total
alias dirsort='du -cha --max-depth=1  | sort -h'



################################################################################
# OTHERS
## calibrate Wacom Cintiq
alias calibrate='xsetwacom --set "8" MaptoOutput 1600x1200+1680+0'



################################################################################
# SCRIPTS
#Pandoc installer cabal haskell
export PATH=/home/boban/.cabal/bin:$PATH

#My Perl scripts
export gouda="/home/boban/Scripts/gouda.pl"
export PATH=$PATH:$gouda

#My sync doc script
export syncdocs=/home/boban/Scripts/sync.sh
export PATH=$PATH:$syncdocs

export bsync=/home/boban/Scripts/bsync.py
export PATH=$PATH:$bsync

# Zenity test for colorpicker
export color=/home/boban/Scripts/color_dialog.sh
export PATH=$PATH:$color

# for install python-virtualenv
export WORKON_HOME=${HOME}/Snakepit
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
	source /usr/local/bin/virtualenvwrapper.sh
elif [ -f /usr/bin/virtualenvwrapper.sh ]; then
	source /usr/bin/virtualenvwrapper.sh
fi



# Commandline fu cli
alias fu='python2 /home/boban/Scripts/fu/fu -a'

################################################################################
# FUNCTIONS
# cd and ls in one
cl() {
    dir=$1
    if [[ -z "$dir" ]]; then
        dir=$HOME
    fi
    if [[ -d "$dir" ]]; then
        cd "$dir"
        ls
    else
        echo "bash: cl: '$dir': Directory not found"
    fi
}

################################################################################
# SIMPLE NOTE TAKER
note () {
    # if file doesn't exist, create it
    if [[ ! -f $HOME/.notes ]]; then
        touch "$HOME/.notes"
    fi

    if ! (($#)); then
        # no arguments, print file
        cat "$HOME/.notes"
    elif [[ "$1" == "-c" ]]; then
        # clear file
        > "$HOME/.notes"
    else
        # add all arguments to file
        printf "%s\n" "$*" >> "$HOME/.notes"
    fi
}


################################################################################
# Archlinux Ultimate Install - .bashrc
# by helmuthdu

################################################################################
## OVERALL CONDITIONALS 
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true

_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true

_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true

_isroot=false
[[ $UID -eq 0 ]] && _isroot=true



################################################################################
## PS1 CONFIG
[[ -f $HOME/.dircolors ]] && eval $(dircolors -b $HOME/.dircolors)
if $_isxrunning; then

[[ -f $HOME/.dircolors_256 ]] && eval $(dircolors -b $HOME/.dircolors_256)

export TERM='xterm-256color'

#user is green	
	B='\[\e[1;38;5;33m\]'
	LB='\[\e[1;38;5;81m\]'
	GY='\[\e[1;32;5;242m\]'
	G='\[\e[1;38;5;82m\]'
	P='\[\e[1;32;5;161m\]'
	PP='\[\e[1;38;5;93m\]'
	R='\[\e[1;38;5;196m\]'
	Y='\[\e[1;32;5;214m\]'
	W='\[\e[0m\]'

# root is red
#GY='\[\e[1;31;5;242m\]'
#P='\[\e[1;31;5;161m\]'
#Y='\[\e[1;31;5;214m\]'


get_prompt_symbol() {
  [[ $UID == 0 ]] && echo "#" || echo "\$"
}

## pwd issue, i just added $PWD for showing working directory 

# export PS1="$GY[$Y\u$GY@$P\h$GY:$B\$PWD\$LB]\$(get_prompt_symbol) "

export PS1="$GY[$Y\u$GY@$P\h$GY:$B\W$LB]\$PWD\$(get_prompt_symbol) "
else
export TERM='xterm-color'
fi


################################################################################
## ALIAS
alias freemem='sudo /sbin/sysctl -w vm.drop_caches=3'
#alias enter_matrix='echo -e "\e[32m"; while :; do for i in {1..16}; do r="$(($RANDOM % 2))"; if [[ $(($RANDOM % 5)) == 1 ]]; then if [[ $(($RANDOM % 4)) == 1 ]]; then v+="\e[1m $r   "; else v+="\e[2m $r   "; fi; else v+="     "; fi; done; echo -e "$v"; v=""; done'


################################################################################
## MODIFIED COMMANDS 
alias ..='cd ..'
alias df='df -h'
alias diff='colordiff'              # requires colordiff package
alias du='du -c -h'
alias free='free -m'                # show sizes in MB
alias grep='grep --color=auto'
alias grep='grep --color=tty -d skip'
alias mkdir='mkdir -p -v'
alias more='less'
alias nano='nano -w'
alias ping='ping -c 5'


################################################################################
## LS 
alias ls='ls -hF --color=auto'
alias lr='ls -R'                    # recursive ls
alias ll='ls -alh'
alias la='ll -A'
alias lm='la | more'


################################################################################
## BASH OPTIONS 
shopt -s cdspell                 # Correct cd typos
shopt -s checkwinsize            # Update windows size on command
shopt -s histappend              # Append History instead of overwriting file
shopt -s cmdhist                 # Bash attempts to save all lines of a multiple-line command in the same history entry
shopt -s extglob                 # Extended pattern
shopt -s no_empty_cmd_completion # No empty completion



################################################################################
## HISTORY CONTROL BOB  
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
export HISTCONTROL=ignoreboth   # ingore duplicates and spaces
export HISTIGNORE='&:ls:ll:la:cd:exit:clear:history'
# shopt -s histappend                      # append to history, don't overwrite it(already done line172)
# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"



################################################################################
## COMPLETION 
complete -cf sudo
if [[ -f /etc/bash_completion ]]; then
  . /etc/bash_completion
fi


################################################################################
## EXPORTS 
export PATH=/usr/local/bin:$PATH
export _JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

################################################################################
#Ruby support
if which ruby &>/dev/null; then
	GEM_DIR=$(ruby -rubygems -e 'puts Gem.user_dir')/bin
	if [[ -d "$GEM_DIR" ]]; then
	  export PATH=$GEM_DIR:$PATH
	fi
	fi
	if which google-chrome-stable &>/dev/null; then
	export CHROME_BIN=/usr/bin/google-chrome-stable
fi

################################################################################
## EDITOR 
#if which vim &>/dev/null; then
#  export EDITOR="vim"
#elif which emacs &>/dev/null; then
#  export EDITOR="emacs -nw"
#else
  export EDITOR="nano"
#fi


################################################################################
# COLORED MANUAL PAGES 
## @see http://www.tuxarena.com/?p=508
## For colourful man pages (CLUG-Wiki style)
if $_isxrunning; then
  export PAGER=less
  export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
  export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
  export LESS_TERMCAP_me=$'\E[0m'           # end mode
  export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
  export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
  export LESS_TERMCAP_ue=$'\E[0m'           # end underline
  export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
fi


################################################################################
## PRIVILEGED ACCESS 
if ! $_isroot; then
  alias sudo='sudo '
  alias scat='sudo cat'
  alias svim='sudo vim'
  alias root='sudo su'
  alias reboot='sudo reboot'
  alias halt='sudo halt'
fi


################################################################################
# PACMAN ALIASES archlinux
if $_isarch; then
  # we're not root
  if ! $_isroot; then
	alias pacman='sudo pacman'
  fi
  alias pacupg='pacman -Syu'            # Synchronize with repositories and then upgrade packages that are out of date on the local system.
  alias pacupd='pacman -Sy'             # Refresh of all package lists after updating /etc/pacman.d/mirrorlist
  alias pacin='pacman -S'               # Install specific package(s) from the repositories
  alias pacinu='pacman -U'              # Install specific local package(s)
  alias pacre='pacman -R'               # Remove the specified package(s), retaining its configuration(s) and required dependencies
  alias pacun='pacman -Rcsn'            # Remove the specified package(s), its configuration(s) and unneeded dependencies
  alias pacinfo='pacman -Si'            # Display information about a given package in the repositories
  alias pacse='pacman -Ss'              # Search for package(s) in the repositories

  alias pacupa='pacman -Sy && sudo abs' # Update and refresh the local package and ABS databases against repositories
  alias pacind='pacman -S --asdeps'     # Install given package(s) as dependencies of another package
  alias pacclean="pacman -Sc"           # Delete all not currently installed package files
  alias pacmake="makepkg -fcsi"         # Make package from PKGBUILD file in current directory
fi

################################################################################
## MULTIMEDIA 
if which get_flash_videos &>/dev/null; then
  alias gfv='get_flash_videos -r 720p --subtitles'
fi
if which simple-mtpfs &>/dev/null; then
  alias android-connect="simple-mtpfs /media/android"
  alias android-disconnect="fusermount -u /media/android"
fi


################################################################################
# TOP 10 COMMANDS 
## copyright 2007 - 2010 Christopher Bratusek
top10() { history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head; }


################################################################################
## up: Goes up many dirs as the number passed as argument, if none goes up by 1 by default
up() {
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++)); do
	d=$d/..
  done
  d=$(echo $d | sed 's/^\///')
  if [[ -z "$d" ]]; then
	d=..
  fi
  cd $d
}

################################################################################
## ARCHIVE EXTRACTOR 
extract() {
  clrstart="\033[1;34m"  #color codes
  clrend="\033[0m"

  if [[ "$#" -lt 1 ]]; then
	echo -e "${clrstart}Pass a filename. Optionally a destination folder. You can also append a v for verbose output.${clrend}"
	exit 1 #not enough args
  fi

  if [[ ! -e "$1" ]]; then
	echo -e "${clrstart}File does not exist!${clrend}"
	exit 2 #file not found
  fi

  if [[ -z "$2" ]]; then
	DESTDIR="." #set destdir to current dir
  elif [[ ! -d "$2" ]]; then
	echo -e -n "${clrstart}Destination folder doesn't exist or isnt a directory. Create? (y/n): ${clrend}"
	read response
	#echo -e "\n"
	if [[ $response == y || $response == Y ]]; then
	  mkdir -p "$2"
	  if [ $? -eq 0 ]; then
		DESTDIR="$2"
	  else
		exit 6 #Write perms error
	  fi
	else
	  echo -e "${clrstart}Closing.${clrend}"; exit 3 # n/wrong response
	fi
  else
	DESTDIR="$2"
  fi

  if [[ ! -z "$3" ]]; then
	if [[ "$3" != "v" ]]; then
	  echo -e "${clrstart}Wrong argument $3 !${clrend}"
	  exit 4 #wrong arg 3
	fi
  fi

  filename=`basename "$1"`

  #echo "${filename##*.}" debug

  case "${filename##*.}" in
	tar)
	  echo -e "${clrstart}Extracting $1 to $DESTDIR: (uncompressed tar)${clrend}"
	  tar x${3}f "$1" -C "$DESTDIR"
	  ;;
	gz)
	  echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
	  tar x${3}fz "$1" -C "$DESTDIR"
	  ;;
	tgz)
	  echo -e "${clrstart}Extracting $1 to $DESTDIR: (gip compressed tar)${clrend}"
	  tar x${3}fz "$1" -C "$DESTDIR"
	  ;;
	xz)
	  echo -e "${clrstart}Extracting  $1 to $DESTDIR: (gip compressed tar)${clrend}"
	  tar x${3}f -J "$1" -C "$DESTDIR"
	  ;;
	bz2)
	  echo -e "${clrstart}Extracting $1 to $DESTDIR: (bzip compressed tar)${clrend}"
	  tar x${3}fj "$1" -C "$DESTDIR"
	  ;;
	zip)
	  echo -e "${clrstart}Extracting $1 to $DESTDIR: (zipp compressed file)${clrend}"
	  unzip "$1" -d "$DESTDIR"
	  ;;
	rar)
	  echo -e "${clrstart}Extracting $1 to $DESTDIR: (rar compressed file)${clrend}"
	  unrar x "$1" "$DESTDIR"
	  ;;
	7z)
	  echo -e  "${clrstart}Extracting $1 to $DESTDIR: (7zip compressed file)${clrend}"
	  7za e "$1" -o"$DESTDIR"
	  ;;
	*)
	  echo -e "${clrstart}Unknown archieve format!"
	  exit 5
	  ;;
  esac
}


################################################################################
## ARCHIVE COMPRESS 
compress() {
	if [[ -n "$1" ]]; then
	FILE=$1
	case $FILE in
	*.tar ) shift && tar cf $FILE $* ;;
	*.tar.bz2 ) shift && tar cjf $FILE $* ;;
	*.tar.gz ) shift && tar czf $FILE $* ;;
	*.tgz ) shift && tar czf $FILE $* ;;
	*.zip ) shift && zip $FILE $* ;;
	*.rar ) shift && rar $FILE $* ;;
	esac
	else
	echo "usage: compress <foo.tar.gz> ./foo ./bar"
	fi
}


################################################################################
## CONVERT TO ISO
to_iso () {
  if [[ $# == 0 || $1 == "--help" || $1 == "-h" ]]; then
	echo -e "Converts raw, bin, cue, ccd, img, mdf, nrg cd/dvd image files to ISO image file.\nUsage: to_iso file1 file2..."
  fi
  for i in $*; do
	if [[ ! -f "$i" ]]; then
	  echo "'$i' is not a valid file; jumping it"
	else
	  echo -n "converting $i..."
	  OUT=`echo $i | cut -d '.' -f 1`
	  case $i in
			*.raw ) bchunk -v $i $OUT.iso;; #raw=bin #*.cue #*.bin
	  *.bin|*.cue ) bin2iso $i $OUT.iso;;
	  *.ccd|*.img ) ccd2iso $i $OUT.iso;; #Clone CD images
			*.mdf ) mdf2iso $i $OUT.iso;; #Alcohol images
			*.nrg ) nrg2iso $i $OUT.iso;; #nero images
				* ) echo "to_iso don't know de extension of '$i'";;
	  esac
	  if [[ $? != 0 ]]; then
		echo -e "${R}ERROR!${W}"
	  else
		echo -e "${G}done!${W}"
	  fi
	fi
  done
}

################################################################################
## REMIND ME, ITS IMPORTANT!
# usage: remindme <time> <text>
# e.g.: remindme 10m "omg, the pizza"
remindme() { sleep $1 && zenity --info --text "$2" & }



################################################################################
## SIMPLE CALCULATOR 
# usage: calc <equation>
calc() {
  if which bc &>/dev/null; then
	echo "scale=3; $*" | bc -l
  else
	awk "BEGIN { print $* }"
  fi
}

################################################################################
# FILE & STRINGS RELATED FUNCTIONS 
## Find a file with a pattern in name 
ff() { find . -type f -iname '*'$*'*' -ls ; }

## Find a file with pattern $1 in name and Execute $2 on it 
fe() { find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }

## Move filenames to lowercase 
lowercase() {
	for file ; do
	  filename=${file##*/}
	  case "$filename" in
	  */* ) dirname==${file%/*} ;;
		* ) dirname=.;;
	  esac
	  nf=$(echo $filename | tr A-Z a-z)
	  newname="${dirname}/${nf}"
	  if [[ "$nf" != "$filename" ]]; then
		mv "$file" "$newname"
		echo "lowercase: $file --> $newname"
	  else
		echo "lowercase: $file not changed."
	  fi
	done
}

## Swap 2 filenames around, if they exist
###(from Uzi's bashrc).
swap() {
	local TMPFILE=tmp.$$

	[[ $# -ne 2 ]] && echo "swap: 2 arguments needed" && return 1
	[[ ! -e $1 ]] && echo "swap: $1 does not exist" && return 1
	[[ ! -e $2 ]] && echo "swap: $2 does not exist" && return 1

	mv "$1" $TMPFILE
	mv "$2" "$1"
	mv $TMPFILE "$2"
}

### Finds directory sizes and lists them for the current directory 
dirsize () {
	du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
	egrep '^ *[0-9.]*M' /tmp/list
	egrep '^ *[0-9.]*G' /tmp/list
	rm -rf /tmp/list
}



################################################################################
## SYSTEMD SUPPORT 
if which systemctl &>/dev/null; then
  start() {
	sudo systemctl start $1.service
  }
  restart() {
	sudo systemctl restart $1.service
  }
  stop() {
	sudo systemctl stop $1.service
  }
  enable() {
	sudo systemctl enable $1.service
  }
  status() {
	sudo systemctl status $1.service
  }
  disable() {
	sudo systemctl disable $1.service
  }
fi


################################################################################
#shot - takes a screenshot of your current window
shot ()
	{
	import -frame -strip -quality 75 "$HOME/Pictures/Screenshot/$(date +%s).png"
	}








### DOTFILE_EXTRAS TOC##############

# ascii fun buba
# ascii fun worm
# ascii fun vis
# ascii fun hond
# myip
# note (n)
# clock
# netinfo
# shot ($HOME/Pictures/Screenshot)
# bu
# extract_simple
# stock
# colored man pages
# function aa_mod_parameters
# function show_mod_parameter_info
# screenfetch
#################################




################################################################################
# ASCII FUN
## BUBA
alias buba='for((P=10**8,Q=P/100,X=320*Q/(`tput cols`-1),Y=210*Q/`tput lines`,y=-105*Q,v=-2\
20*Q,x=v;y<105*Q;x=v,y+=Y));do for((;x<P;a=b=i=k=c=0,x+=X));do for((;a*a+b*b<2*\
P*P&&i++<99;a=((c=a)*a-b*b)/P+x,b=2*c*b/P+y));do :;done;(((j=(i<99?i%16:0)+30)>\
37?k=1,j-=8:0));echo -ne "\E[$k;$j"mE;done;echo -e "\E[0m";done #Charles Cooke'

## WORM
alias worm='echo -ne "\033#8";X=`tput cols`;Y=`tput lines`;((a=$X/2));((b=$Y/2));d=1;while case $d in 0)((a=a<2?X:a-1));;1)((b=b<2?Y:b-1));;2)((a=a==X?1:a+1));;3)((b=b==Y?1:b+1));; esac;do ((c=b+a*X));v=${k[c]:- };[ $v. = @. ]&&{((d=d>2?0:d+1));k[c]="";}||{(( d=d<1?3:d-1));k[c]=@;};echo -ne "\033[$b;${a}H$v";done'

## ASCIIQUARIUM ??
#alias vis ="perl /usr/bin/asciiquarium"

## Hondje zingen
alias hond='vlc -I dummy -V caca `youtube-dl -g "https://www.youtube.com/watch?v=_7vkRTylYoA"`'


################################################################################
## myip - finds your current ip if your connected to the internet
myip ()
{
lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g'
}


################################################################################    
### SIMPLE NOTE TAKER
n () {
# if file doesn't exist, create it
if [[ ! -f $HOME/.note ]]; then
touch "$HOME/.note"
fi

if ! (($#)); then
# no arguments, print file
cat "$HOME/.note"
elif [[ "$1" == "-c" ]]; then
# clear file
> "$HOME/.note"
else
# add all arguments to file
printf "%s\n\n" "$*" >> "$HOME/.note"
fi
}
################################################################################	
## CLOCK - A BASH CLOCK THAT CAN RUN IN YOUR TERMINAL WINDOW.
clock ()
{
while true;do clear;echo "===========";date +"%r";echo "===========";sleep 1;done
}

################################################################################
## NETINFO - SHOWS NETWORK INFORMATION FOR YOUR SYSTEM
netinfo ()
{
echo "--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
echo "${myip}"
echo "---------------------------------------------------"
}

################################################################################
## SHOT - TAKES A SCREENSHOT OF YOUR CURRENT WINDOW
shot ()
{
import -frame -strip -quality 75 "$HOME/Pictures/Screenshot/$(date +%s).png"
}

################################################################################
## BU - BACK UP A FILE. USAGE "BU FILENAME.TXT"
bu () { cp $1 ${1}-`date +%Y%m%d%H%M`.backup ; }

################################################################################
## EXTRACT - EXTRACT MOST COMMON COMPRESSION TYPES
extract_simple () {
if [ -f $1 ] ; then
case $1 in
*.tar.bz2)   tar xjf $1        ;;
*.tar.gz)    tar xzf $1     ;;
*.bz2)       bunzip2 $1       ;;
*.rar)       rar x $1     ;;
*.gz)        gunzip $1     ;;
*.tar)       tar xf $1        ;;
*.tbz2)      tar xjf $1      ;;
*.tgz)       tar xzf $1       ;;
*.zip)       unzip $1     ;;
*.Z)         uncompress $1  ;;
*.7z)        7z x $1    ;;
*)           echo "'$1' cannot be extracted via extract()" ;;
esac
else
echo "'$1' is not a valid file"
fi
}


################################################################################
## STOCK PRICES - CAN BE CALLED TWO WAYS.
## STOCK NOVL (THIS SHOWS STOCK PRICING)  #STOCK "NOVELL"  
stock ()
{
stockname=`lynx -dump http://finance.yahoo.com/q?s=${1} | grep -i ":${1})" | sed -e 's/Delayed.*$//'`
stockadvise="${stockname} - delayed quote."
declare -a STOCKINFO
STOCKINFO=(` lynx -dump http://finance.yahoo.com/q?s=${1} | egrep -i "Last Trade:|Change:|52wk Range:"`)
stockdata=`echo ${STOCKINFO[@]}`
if [[ ${#stockname} != 0 ]] ;then
echo "${stockadvise}"
echo "${stockdata}"
else
stockname2=${1}
lookupsymbol=`lynx -dump -nolist http://finance.yahoo.com/lookup?s="${1}" | grep -A 1 -m 1 "Portfolio" | grep -v "Portfolio" | sed 's/\(.*\)Add/\1 /'`
if [[ ${#lookupsymbol} != 0 ]] ;then
echo "${lookupsymbol}"
else
echo "Sorry $USER, I can not find ${1}."
fi
fi
}


################################################################################
## SEE KERNEL MODULES LOADED AND PARAMETERS
function aa_mod_parameters () 
{ 
N=/dev/null;
C=`tput op` O=$(echo -en "\n`tput setaf 2`>>> `tput op`");
for mod in $(cat /proc/modules|cut -d" " -f1);
do
md=/sys/module/$mod/parameters;
[[ ! -d $md ]] && continue;
m=$mod;
d=`modinfo -d $m 2>$N | tr "\n" "\t"`;
echo -en "$O$m$C";
[[ ${#d} -gt 0 ]] && echo -n " - $d";
echo;
for mc in $(cd $md; echo *);
do
de=`modinfo -p $mod 2>$N | grep ^$mc 2>$N|sed "s/^$mc=//" 2>$N`;
echo -en "\t$mc=`cat $md/$mc 2>$N`";
[[ ${#de} -gt 1 ]] && echo -en " - $de";
echo;
done;
done
}


################################################################################
## MORE KERNEL MODULES INFO WITH PARAMETERS AND COLOR
function show_mod_parameter_info ()
{
if tty -s <&1
then
green="\e[1;32m"
yellow="\e[1;33m"
cyan="\e[1;36m"
reset="\e[0m"
else
green=
yellow=
cyan=
reset=
fi
newline="
"

while read mod
do
md=/sys/module/$mod/parameters
[[ ! -d $md ]] && continue
d="$(modinfo -d $mod 2>/dev/null | tr "\n" "\t")"
echo -en "$green$mod$reset"
[[ ${#d} -gt 0 ]] && echo -n " - $d"
echo
pnames=()
pdescs=()
pvals=()
pdesc=
add_desc=false
while IFS="$newline" read p
do
if [[ $p =~ ^[[:space:]] ]]
then
pdesc+="$newline    $p"
else
$add_desc && pdescs+=("$pdesc")
pname="${p%%:*}"
pnames+=("$pname")
pdesc=("    ${p#*:}")
pvals+=("$(cat $md/$pname 2>/dev/null)")
fi
add_desc=true
done < <(modinfo -p $mod 2>/dev/null)
$add_desc && pdescs+=("$pdesc")
for ((i=0; i<${#pnames[@]}; i++))
do
printf "  $cyan%s$reset = $yellow%s$reset\n%s\n" \
${pnames[i]} \
"${pvals[i]}" \
"${pdescs[i]}"
done
echo

done < <(cut -d' ' -f1 /proc/modules | sort)
}


################################################################################
# SCREENFETCH
#screenfetch
