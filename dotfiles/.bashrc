###################################################################
##                         		                         ##
##                                                               ##
##                   	      boban-dj				 ##
##                      Use at your own risk!                    ##
##                                                               ##
##  This software released under the GNU General Public License. ##
##								 ##	
###################################################################


################################################################################
# APACHE MYSQLD
##apache and mysql start,stop restart
alias on='sudo systemctl start httpd;sudo systemctl start mysqld;'
alias off='sudo systemctl stop httpd;sudo systemctl stop mysqld;'
alias both='sudo systemctl restart httpd;sudo systemctl restart mysqld;'

## carry over aliases in root .bashrc
alias sudo='sudo '



################################################################################
# FILESYSTEM
## see permissions in numbers
alias lso="ls -alG | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print}'"

##alias folders-files
alias lsdirs="ls -d -1 $PWD/**"
alias lsfiles="ls -d -1 $PWD/*.*"

##current dirsize,sort by size low-high, show total
alias dirsort='du -cha --max-depth=1  | sort -h'


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

# user prompt is green	
	B='\[\e[1;38;5;33m\]'
	LB='\[\e[1;38;5;81m\]'
	GY='\[\e[1;32;5;242m\]'
	G='\[\e[1;38;5;82m\]'
	P='\[\e[1;32;5;161m\]'
	PP='\[\e[1;38;5;93m\]'
	R='\[\e[1;38;5;196m\]'
	Y='\[\e[1;32;5;214m\]'
	W='\[\e[0m\]'

# root prompt is red
#GY='\[\e[1;31;5;242m\]'
#P='\[\e[1;31;5;161m\]'
#Y='\[\e[1;31;5;214m\]'


get_prompt_symbol() {
  [[ $UID == 0 ]] && echo "#" || echo "\$"
}

export PS1="$GY[$Y\u$GY@$P\h$GY:$B\W$LB]\$PWD\$(get_prompt_symbol) "
else
export TERM='xterm-color'
fi

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

