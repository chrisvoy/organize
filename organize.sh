#!/bin/bash
SOURCEDIR=$1
DESTDIR=$2
MONTHS=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

#check if strings ends with "/"
case $SOURCEDIR in
	*/) SOURCEDIR=$SOURCEDIR"*";;
	*) SOURCEDIR=$SOURCEDIR"/*";;
esac
case $DESTDIR in 
	*/) echo "ends";;
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
