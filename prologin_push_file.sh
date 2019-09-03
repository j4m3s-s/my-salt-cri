#!/usr/bin/env sh

# Copy file to web server

set -e

copy_file()
{
    USER="$1"
    PASS="$2"
    ADDR="$3"
    FILE="$4"

    l1=$(expr substr "$USER" 1 1)
    l2=$(expr substr "$USER" 1 2)
    afs_u="/afs/cri.epita.net/user/$l1/$l2/$USER/u"

    echo "$PASS" | kinit "$USER"
    aklog

    mkdir -p "$USER"
    mount --bind "$afs_u" "$USER"
    wget "http://$ADDR/$FILE" -o "$USER/$FILE"

    # umount
    umount "$USER"
    kdestroy
}

# read csv file
while read -r line; do
    USER=$(echo "$line" | cut -d "," -f3)
    PASS=$(echo "$line" | cut -d "," -f4)

    echo "Read $USER"
    copy_file "$USER" "$PASS" "127.0.0.1" "tata"

done < "$1"
