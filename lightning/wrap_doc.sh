#!/bin/bash
echo THIS HAS NOT BEEN UPDATED TO WORK ON GITHUB
exit

for f in `find documentation -name '*.html'`
do
	echo " wrapping file $f ..."

        echo -e "$(cat .pre) $(cat $f ) $(cat .post)" > "$f"

	echo "done!"
done
