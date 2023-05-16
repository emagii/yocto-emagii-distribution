#!/bin/bash

usage()
{
	echo "Usage:	$0 <disk>"
	echo "Example:"
	echo "		$0 /dev/sdc"
	echo
	echo "	Will not partition /dev/sda nor /dev/sdb"
}

if [ -z "$1" ] ; then
	usage
	exit 1
else
	DISK="$1"
fi

case $DISK in

	"/dev/sda"|"/dev/sdb")
		usage
		exit 1
		;;
	*)
esac

AVAILABLE=$(ls ${DISK} | wc -l)
printf "AVAILABLE=\"${AVAILABLE}\"\n"


if [ "x${AVAILABLE}" == "x1" ] ; then
	DISK_INFO=$(sudo fdisk -l ${DISK} | grep GiB | sed -e 's/sektorer/sectors/g')
	DISK_SIZE=$(echo ${DISK_INFO} | sed  's/.*: \([0-9]*\),\([0-9]*\) GiB.*/\1,\2 GiB/')
	       GB=$(echo ${DISK_INFO} | sed  's/.*: \([0-9]*\),\([0-9]*\) GiB.*/\1/')
	       MB=$(echo ${DISK_INFO} | sed  's/.*: \([0-9]*\),\([0-9]*\) GiB.*/\2/')
	DISK_SECT=$(echo ${DISK_INFO} | sed  's/.* byte, \([0-9]*\) sectors/\1/')
fi

_64GB=0
for size in $(seq 57 65) ; do
  if [ "$size" == "$GB" ] ; then
     _64GB=1
  fi
done

_32GB=0
for size in $(seq 27 33) ; do
  if [ "$size" == "$GB" ] ; then
     _32GB=1
  fi
done

#
# $1 = <disk>; Example /dev/sdc1
# $2 = <label>
mkfs_vfat()
{
	if [ -e "$2" ] ; then
		mkfs.vfat -n "$1" $2
	else
		echo "$2: not found"
	fi
}

#
# $1 = <disk>; Example /dev/sdc1
# $2 = <label>
mkfs_ext4()
{
	if [ -e "$2" ] ; then
		mkfs.ext4 -L "$1" $2
	else
		echo "$2: not found"
	fi
}

format_64GB()
{
	mkfs_vfat HIDDEN	${DISK}1
	mkfs_ext4 SETTINGS	${DISK}5
	mkfs_vfat BOOT		${DISK}6
	mkfs_ext4 ROOTA		${DISK}7
	mkfs_ext4 ROOTB		${DISK}8
	mkfs_ext4 DATA		${DISK}9
}


printf "DISK_INFO=\"$DISK_INFO\"\n"
printf "DISK_SIZE=$DISK_SIZE\n"
printf "DISK_INFO=$DISK_SECT sectors\n"
printf "GB=       ${GB}\n"
printf "MB=       ${MB}\n"

if [ "$_64GB" = 1 ] ; then
  format_64GB
else
  echo  "_64GB=${_64GB}"
fi
