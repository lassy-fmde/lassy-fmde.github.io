#!/bin/bash

echo -n "lightning.gforge.uni.lu login [$USER]: "
read -e USERNAME

# Use name of currently logged in user if none given
if [ "x$USERNAME" == "x" ]; then
    USERNAME=$USER;
fi

# Copy while deleting files that exist in the
# destination but not in the source, and excluding
# SVN and Eclipse metadata.
rsync -f "exclude .svn" -f "exclude .project" -f "exclude .settings" -r --delete . "$USERNAME@lightning.gforge.uni.lu:/var/lib/gforge/chroot/home/groups/lightning/htdocs/"
