#! /bin/bash

# === HEAVY LIFTING ===
#ssc shopt -s extglob extquote

[ -f VERSION-FILE ] && . VERSION-FILE || VERSION="@DEV_VERSION@"
version() {
    cat <<-EndVersion
		forgettinGTD Command Line Interface v$VERSION
		Based on TODO.TXT by Gina Trapani (http://ginatrapani.org)
		License: GPL, http://www.gnu.org/copyleft/gpl.html
	EndVersion
    exit 1
}

# Set script name and full path early.
FTD_SH=$(basename "$0")
FTD_FULL_SH="$0"
export FTD_SH FTD_FULL_SH

oneline_usage="$FTD_SH [-fhvV] action <path to file/folder>"

usage()
{
    cat <<-EndUsage
		Usage: $oneline_usage
		Try '$FTD_SH -h' for more information.
	EndUsage
    exit 1
}

shorthelp()
{
    cat <<-EndHelp
		  Usage: $oneline_usage

		  Actions:
		    close|c <path to file/folder>
		    help [ACTION...]
		    shorthelp
	EndHelp
	exit 0
}

help()
{
    cat <<-EndOptionsHelp
		  Usage: $oneline_usage

		  Options:
		    -c
		        Color mode
		    -f
		        Forces actions without confirmation or interactive input
		    -h
		        Display a short help message; same as action "shorthelp"
		    -p
		        Plain mode turns off colors
		    -v
		        Verbose mode turns on confirmation messages
		    -vv
		        Extra verbose mode prints some debugging information and
		        additional help text
		    -V
		        Displays version, license and credits

	EndOptionsHelp

    [ $FTD_VERBOSE -gt 1 ] && cat <<-'EndVerboseHelp'
		  Environment variables:
		    FTD_FORCE=1                 is same as option -f
		    FTD_PLAIN                   is same as option -p (1)/-c (0)
		    TFD_VERBOSE=1               is same as option -v

	EndVerboseHelp

	actionsHelp
}

actionsHelp()
{
    cat <<-EndActionsHelp
		  Actions:
		    close <path to file/folder>
		    c <path to file/folder>
		      Marks an action as closed. 
		      Choose action to close by path to file or folder.
		      Allows Wildcards in name of file or folder.
		      Already closed actions will be newly timestamped.
	EndActionsHelp
}


actionUsage()
{
    for actionName
    do
        builtinActionUsage=$(actionsHelp | sed -n -e "/^    ${actionName//\//\\/} /,/^\$/p" -e "/^    ${actionName//\//\\/}$/,/^\$/p")
        if [ "$builtinActionUsage" ]; then
            echo "$builtinActionUsage"
            echo
        else
            die "TODO: No action \"${actionName}\" exists."
        fi
    done
}

die()
{
    echo "$*"
    exit 1
}

#Preserving environment variables so they don't get clobbered by the config file
OVR_FTD_FORCE="$FTD_FORCE"
OVR_FTD_PLAIN="$FTD_PLAIN"
OVR_FTD_VERBOSE="$FTD_VERBOSE"

# Prevent GREP_OPTIONS from malforming grep's output
GREP_OPTIONS=""

# == PROCESS OPTIONS ==
while getopts ":fhcvV" Option
do
  case $Option in
    c )
        OVR_FTD_PLAIN=0
        ;;
    f )
        OVR_FTD_FORCE=1
        ;;
    h )
		shorthelp
        ;;
    p )
        OVR_FTD_PLAIN=1
        ;;
    v )
        : $(( FTD_VERBOSE++ ))
        ;;
    V )
        version
        ;;
  esac
done
shift $(($OPTIND - 1))

# defaults if not yet defined
FTD_VERBOSE=${FTD_VERBOSE:-1}
FTD_PLAIN=${FTD_PLAIN:-0}
FTD_FORCE=${FTD_FORCE:-0}

# Export all FTD_* variables
export ${!FTD_@}

# Default color map
export NONE=''
export BLACK='\\033[0;30m'
export RED='\\033[0;31m'
export GREEN='\\033[0;32m'
export BROWN='\\033[0;33m'
export BLUE='\\033[0;34m'
export PURPLE='\\033[0;35m'
export CYAN='\\033[0;36m'
export LIGHT_GREY='\\033[0;37m'
export DARK_GREY='\\033[1;30m'
export LIGHT_RED='\\033[1;31m'
export LIGHT_GREEN='\\033[1;32m'
export YELLOW='\\033[1;33m'
export LIGHT_BLUE='\\033[1;34m'
export LIGHT_PURPLE='\\033[1;35m'
export LIGHT_CYAN='\\033[1;36m'
export WHITE='\\033[1;37m'
export DEFAULT='\\033[0m'

# === APPLY OVERRIDES
if [ -n "$OVR_FTD_FORCE" ] ; then
  TODOTXT_FORCE="$OVR_FTD_FORCE"
fi
if [ -n "$OVR_FTD_PLAIN" ] ; then
  TODOTXT_PLAIN="$OVR_FTD_PLAIN"
fi
if [ -n "$OVR_FTD_VERBOSE" ] ; then
  TODOTXT_VERBOSE="$OVR_FTD_VERBOSE"
fi

ACTION=${1}
[ -z "$ACTION" ]    && usage

# == HANDLE ACTION ==
action=$( printf "%s\n" "$ACTION" | tr 'A-Z' 'a-z' )

case $action in
"close" | "c")
	shift
    [ -z "$1" ] && die "usage: $FTD_SH close <path to file/folder>"
    [ ! -e "$1" ] && die "$1 does not exist"
    for actionname in $1
    do
    	echo "Closing Action '$actionname'..."
    	newactionname=$(printf "x %s %s" $(date +'%Y-%d-%m') "$actionname")
	    if [ $FTD_VERBOSE -gt 0 ]; then
	    	echo "Renaming from $actionname to $newactionname"
	    fi
    	mv "$actionname" "$newactionname"
    done
    ;;
"help" )
    shift  ## Was help; new $1 is first help topic / action name
    if [ $# -gt 0 ]; then
        # Don't use PAGER here; we don't expect much usage output from one / few actions.
        actionUsage "$@"
    else
        if [ -t 1 ] ; then # STDOUT is a TTY
            if which "${PAGER:-less}" >/dev/null 2>&1; then
                # we have a working PAGER (or less as a default)
                help | "${PAGER:-less}" && exit 0
            fi
        fi
        help # just in case something failed above, we go ahead and just spew to STDOUT
    fi
    ;;

"shorthelp" )
    if [ -t 1 ] ; then # STDOUT is a TTY
        if which "${PAGER:-less}" >/dev/null 2>&1; then
            # we have a working PAGER (or less as a default)
            shorthelp | "${PAGER:-less}" && exit 0
        fi
    fi
    shorthelp # just in case something failed above, we go ahead and just spew to STDOUT
    ;;
* )
    usage;;
esac
