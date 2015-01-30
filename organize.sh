#!/bin/bash
SOURCEDIR=$1"*"

DESTDIR=$2

for file in $SOURCEDIR
do
	echo "Copying file: $file..."
	YEAR=`stat -f "%Sm" -t "%Y" $file`
	MONTH=`stat -f "%Sm" -t "%m" $file`

	DEST=$DESTDIR$YEAR"/"
	if [ -d "$DEST" ]; then
		echo "Exists"
	fi
done