#!/bin/bash

for f in `find documentation -name '*.html'`
do
	echo " wrapping file $f ..."

        echo -e "$(cat .pre) $(cat $f ) $(cat .post)" > "$f"

	echo "done!"
done 
