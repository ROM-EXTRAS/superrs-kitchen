#!/sbin/sh

# configure.sh by SuperR. @XDA

# Do not edit this file unless you know what you are doing

SLOT=$(cat /proc/cmdline 2>/dev/null | tr ' ' '\n' | grep slot | cut -d'=' -f2)
byname=
rm -f /tmp/config
if [ $SLOT ]; then
	echo "slotnum=$SLOT" >> /tmp/config
fi
for i in system SYSTEM APP system_a system_b; do
    byname=$(echo /dev/block/platform/*/by-name/$i | grep -v "\*" || echo /dev/block/platform/*/*/by-name/$i | grep -v "\*" || echo /dev/block/*/by-name/$i | grep -v "\*")
    if [ $(readlink $byname) ]; then
		if [ ! $SLOT && $(basename "$byname" | grep system_) ]; then
			SLOT="_$(basename $byname | cut -d'_' -f2)"
			echo "slotnum=$SLOT" >> /tmp/config
		fi
    	byname2=$(dirname $byname)
		echo "byname=$byname2" >> /tmp/config
		echo "system=$byname$SLOT" >> /tmp/config
		break
    fi
done
for i in vendor VENDOR VNR vendor_a vendor_b; do
	if [ $(readlink $byname2/$i) ]; then
		echo "vendor=$byname2/$i$SLOT" >> /tmp/config
		break
	fi
done
for i in userdata USERDATA UDA userdata_a userdata_b; do
	if [ $(readlink $byname2/$i) ]; then
		echo "data=$byname2/$i" >> /tmp/config
		break
	fi
done
for i in boot BOOT LNX boot_a boot_b; do
	if [ $(readlink $byname2/$i) ]; then
		echo "boot=$byname2/$i$SLOT" >> /tmp/config
		break
	fi
done
for i in kernel KERNEL Kernel kernel_a kernel_b; do
	if [ $(readlink $byname2/$i) ]; then
		echo "kernel=$byname2/$i$SLOT" >> /tmp/config
		break
	fi
done
for i in ramdisk RAMDISK ramdisk_a ramdisk_b; do
	if [ $(readlink $byname2/$i) ]; then
		echo "ramdisk=$byname2/$i$SLOT" >> /tmp/config
		break
	fi
done
if [ $(readlink $byname2/version) ]; then
	echo "version=$byname2/version$SLOT" >> /tmp/config
	break
fi
if [ $(readlink $byname2/product) ]; then
	echo "product=$byname2/product$SLOT" >> /tmp/config
	break
fi
if [ $(readlink $byname2/cust) ]; then
	echo "cust=$byname2/cust$SLOT" >> /tmp/config
	break
fi