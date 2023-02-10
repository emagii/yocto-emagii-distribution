#!/bin/sh

usage()
{
	echo "usage: $0  <MACH>"
	echo "MACH = { rpi3|rpi4|sam|sama5|bone|bb|beaglebone }"
}

if [ -z "$1" ] ; then
	usage
	exit 1
fi

case "$1" in
rpi3)
	MACH=raspberrypi3-64
	;;
rpi4)
	MACH=raspberrypi4-64
	;;
sama5|sam)
	MACH=sama5d3-xplained
	;;
bone|bb|beaglebone)
	MACH=beaglebone-yocto
	;;
*)
	usage
	exit 1
	;;
esac
echo	"Selecting MACH=$MACH"

sed -i 's/^MACHINE.*/MACHINE ??= "unknown"/g' conf/local.conf
sed -i "s/unknown/$MACH/g"  conf/local.conf

