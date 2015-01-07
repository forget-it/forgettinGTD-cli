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

oneline_usage="$FTD_SH [-todo]"

usage()
{
    cat <<-EndUsage
		Usage: $oneline_usage
		Try '$FTD_SH -h' for more information.
	EndUsage
    exit 1
}

usage "$@"
