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

if [ "x${AVAILABLE}" == "x1" ] ; then
	DISK_INFO=$(sudo fdisk -l /dev/sdc | grep GiB | sed -e 's/sektorer/sectors/g')
	DISK_SIZE=$(echo ${DISK_INFO} | sed  's/.*: \([0-9,]* GiB\).*/\1/')
	DISK_SECT=$(echo ${DISK_INFO} | sed  's/.* byte, \([0-9]*\) sectors/\1/')
fi


printf "DISK_INFO=\"$DISK_INFO\"\n"
printf "DISK_SIZE=$DISK_SIZE\n"
printf "DISK_INFO=$DISK_SECT sectors\n"




#/dev/sdc5                     30320          76        27951   1% /media/ulf/SETTINGS
#/dev/sdc6                    258094       50756       207339  20% /media/ulf/boot
#/dev/sdc7                  25860480    10767416     13754084  44% /media/ulf/root
#/dev/sdc8                    499284          36       462552   1% /media/ulf/data


#/dev/sdc1 : start=        2048, size=     5972562, type=e	W95 FAT16 (LBA)
#/dev/sdc2 : start=     5974610, size=    54547886, type=5	extended
#/dev/sdc5 : start=     5980160, size=       65534, type=83	Linux
#/dev/sdc6 : start=     6045696, size=      524286, type=c	W95 FAT32 (LBA)
#/dev/sdc7 : start=     6569984, size=    52903934, type=83	Linux
#/dev/sdc8 : start=    59473920, size=     1048576, type=83	Linux




