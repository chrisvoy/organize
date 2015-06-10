#!/bin/bash
MONTHS=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
usage() { echo "Usage: organize.sh -s <SOURCEDIR> -d <DESTDIR>" 1>&2; exit 1; }

IFSBU=$IFS
IFS=$(echo -en "\n\b")

#parse parameters
while getopts ":s:d:" o; do
	case "${o}" in
		s) 
		   SOURCEDIR=${OPTARG}
		   ;;
		d) 
		   DESTDIR=${OPTARG}
		   ;;
		*) 
		   usage
	   	   ;;
   esac
done
if [ -z "${SOURCEDIR}" ] || [ -z "${DESTDIR}" ]; then
    usage
fi

#check if strings ends with "/"
case $SOURCEDIR in
	*/) SOURCEDIR=$SOURCEDIR"*";;
	*) SOURCEDIR=$SOURCEDIR"/*";;
esac
case $DESTDIR in 
	*/) ;;
	*) DESTDIR=$DESTDIR"/";;
esac

for file in $SOURCEDIR
do
	
	YEAR=`stat -f "%Sm" -t "%Y" "$file"`
	MONTHNO=`stat -f "%Sm" -t "%m" "$file"`
	MONTH=${MONTHS[$MONTHNO-1]}

	DEST=$DESTDIR$YEAR"/"
	if [ ! -d "$DEST" ]; then
		mkdir $DEST
	fi
	DEST=$DESTDIR$YEAR"/"$MONTH"/"
	if [ ! -d "$DEST" ]; then
		mkdir $DEST
	fi

	filename=$(basename "$file")
	extension="${filename##*.}"
	filename="${filename%.*}"

	#if file exists in destination
	if [[ -e $DEST$filename"."$extension ]] ; then
	    i=1
	    while [[ -e $DEST$filename"-"$i"."$extension ]] ; do
	        let i++
	    done
	    name=$filename"-"$i"."$extension
	    #echo "Copying "$file" to "$DEST$name
		cp -v $file $DEST$name
	else
		#echo "Copying "$file" to: "$DEST
		cp -v $file $DEST
	fi
done
IFS=$IFSBU
