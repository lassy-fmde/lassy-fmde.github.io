#!/bin/bash


cd ~/Desktop/Lightning/website

echo "copy updateSite from workspace ..."
cp -fr ~/workspace/lu.uni.lightning.update-site/* update-site/ 
echo -e "ok !\n"

echo "copy documentation from workspace ..."
cp -fr ~/workspace/Lightning-plugin/html/* documentation/ 
echo -e "ok !\n"

echo "wrap documentation in website HTML"
./wrap_doc.sh
echo -e "ok !\n"

echo "deploying website ..."
./deploy.sh 
echo -e "ok !\n"

echo "connecting to ssh and change permissions ..."
ssh lgammaitoni@gforge.uni.lu 'cd ../../groups/lightning/htdocs/ ; chmod 777 * -R'
echo -e "ok ! \n"


