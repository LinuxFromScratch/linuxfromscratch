#by leon 2017-11-21

source ./common.sh

CUR_DIR=$PWD

######################################################################
# Parameter Verification
######################################################################
dependence_options="libnl/openssl/libtommath/expat/dbus/gettext/zlib/"\
"libffi/glib/wireless_tools/ffmpeg/wpa_supplicant/mxml/parson_json/"\
"ncurses/gdb"

#
if [ $# -lt 6 ];then
	ERR [$FUNCNAME-$LINENO] "usage: $0 [language] [clibs] [unit] [action] [arch] [soc] [dependence]"
	CMD [$FUNCNAME-$LINENO] "language options: [c/cpp]"
	CMD [$FUNCNAME-$LINENO] "clibs options: [uclibc/glibc]"
	CMD [$FUNCNAME-$LINENO] "unit options: [wpa_supplicant/qt/none]"
	CMD [$FUNCNAME-$LINENO] "action options: [make/clean/install/uninstall]"
	CMD [$FUNCNAME-$LINENO] "arch options: [arm/x86/mips]"
	CMD [$FUNCNAME-$LINENO] "soc options: [goke/hi3518e/hi3518ev200/xilink]"
	CMD [$FUNCNAME-$LINENO] "dependence options: [${dependence_options}]"
	exit 1
fi

language=$1
LOG "language=$language"
if [[ "$language" == "c" ]] ;then
	export LINUX_COMPILER="gcc"
elif [[ "$language" == "cpp" ]] ;then
	export LINUX_COMPILER="g++"
else
	 ERR [$FUNCNAME-$LINENO] "language: $language unsupport..."
	 exit 1
fi


clibs=$2
LOG "clibs=$clibs"
if [ "$clibs" != "uclibc" ] \
&& [ "$clibs" != "glibc" ] ;then
	 ERR [$FUNCNAME-$LINENO] "clibs: $clibs unsupport..."
	 exit 1
fi

unit=$3
LOG "unit=$unit"
if [ "$unit" != "wpa_supplicant" ] \
&& [ "$unit" != "qt" ] \
&& [ "$unit" != "none" ] ;then
	 ERR [$FUNCNAME-$LINENO] "unit: $unit unsupport..."
	 exit 1
fi

action=$4
LOG "action=$action"
if [ "$action" != "make" ] \
&& [ "$action" != "clean" ] \
&& [ "$action" != "install" ] \
&& [ "$action" != "uninstall" ] ;then
	 ERR [$FUNCNAME-$LINENO] "action: $action unsupport..."
	 exit 1
fi


arch=$5
LOG "arch=$arch"
if [ "$arch" != "arm" ] \
&& [ "$arch" != "x86" ] \
&& [ "$arch" != "mips" ] ;then
	 ERR [$FUNCNAME-$LINENO] "arch: $arch unsupport..."
	 exit 1
fi


soc=$6
LOG "soc=$soc"
if [[ "$soc" == "goke" ]] ;then
	if [[ "$clibs" == "glibc" ]] ;then
		ERR [$FUNCNAME-$LINENO] "clibs: $clibs unsupport..."
		exit 1
	elif [[ "$clibs" == "uclibc" ]] ;then 
		export ARM_TOOL_CHAINS_PREFIX="arm-goke-linux-"
		export ARM_HOSTNAME="arm-goke-linux"
	else
		ERR [$FUNCNAME-$LINENO] "clibs: $clibs unsupport..."
		exit 1
	fi
elif [[ "$soc" == "hi3518e" ]] ;then 
	if [[ "$clibs" == "glibc" ]] ;then
		ERR [$FUNCNAME-$LINENO] "clibs: $clibs unsupport..."
		exit 1
	elif [[ "$clibs" == "uclibc" ]] ;then 
		export ARM_TOOL_CHAINS_PREFIX="arm-hisiv100nptl-linux-"
		export ARM_HOSTNAME="arm-hisiv100nptl-linux"
	else
		ERR [$FUNCNAME-$LINENO] "clibs: $clibs unsupport..."
		exit 1
	fi
elif [[ "$soc" == "hi3518ev200" ]] ;then
	if [[ "$clibs" == "glibc" ]] ;then
		export ARM_TOOL_CHAINS_PREFIX="arm-hisiv400-linux-"
		export ARM_HOSTNAME="arm-hisiv400-linux"
	elif [[ "$clibs" == "uclibc" ]] ;then 
		export ARM_TOOL_CHAINS_PREFIX="arm-hisiv300-linux-"
		export ARM_HOSTNAME="arm-hisiv300-linux"
	else
		ERR [$FUNCNAME-$LINENO] "clibs: $clibs unsupport..."
		exit 1
	fi
elif [[ "$soc" == "xilink" ]] ;then
	if [[ "$clibs" == "glibc" ]] ;then
		export ARM_TOOL_CHAINS_PREFIX="arm-xilinx-linux-gnueabi-"
		export ARM_HOSTNAME="arm-xilinx-linux-gnueabi"
	elif [[ "$clibs" == "uclibc" ]] ;then 
		export ARM_TOOL_CHAINS_PREFIX="arm-xilinx-linux-gnueabi-"
		export ARM_HOSTNAME="arm-xilinx-linux-gnueabi"
	else
		ERR [$FUNCNAME-$LINENO] "clibs: $clibs unsupport..."
		exit 1
	fi	
else
	ERR [$FUNCNAME-$LINENO] "soc: $soc unsupport..."
	exit 1	 
fi

LOG "ARM_TOOL_CHAINS_PREFIX=$ARM_TOOL_CHAINS_PREFIX"
LOG "ARM_HOSTNAME=$ARM_HOSTNAME"

######################################################################
# do dependences
######################################################################
dependences="$(until [ -z "$7" ]; do echo "$7" ; shift ;done)"

LOG "dependences: `echo $dependences | xargs`"

if [[ "$action" == "make" ]] ;then
	# for loop
	for i in $dependences 
	do 
		CMD [$FUNCNAME-$LINENO] $i;
		if [ "$i" != "libnl" ] \
		&& [ "$i" != "openssl" ] \
		&& [ "$i" != "libtommath" ] \
		&& [ "$i" != "expat" ] \
		&& [ "$i" != "dbus" ] \
		&& [ "$i" != "gettext" ] \
		&& [ "$i" != "zlib" ] \
		&& [ "$i" != "libffi" ] \
		&& [ "$i" != "glib" ] \
		&& [ "$i" != "wireless_tools" ] \
		&& [ "$i" != "ffmpeg" ] \
		&& [ "$i" != "wpa_supplicant" ] \
		&& [ "$i" != "mxml" ] \
		&& [ "$i" != "parson_json" ] \
		&& [ "$i" != "ncurses" ] \
		&& [ "$i" != "gdb" ] \
		&& [ "$i" != "libxml2" ] ;then
			 ERR [$FUNCNAME-$LINENO] "dependence: $i unsupport..."
			 exit 1
		fi
		cd $CUR_DIR/Dependencies		 
		
		# get dirname
		for j in $(find ./ -maxdepth 1 -type d | xargs)
		do 
	    dirname="`echo $j | cut -d '/' -f2`"    
	    if [[ "$dirname" == *$i* ]] ;then
	    	break;
	    fi
		done
		
    #if dir exsit , then delete DIR
		if [[ -d $dirname ]] ;then
			LOG "rm -fr $dirname"
			rm -fr $dirname
		fi
		# release tar file.
		tar -xvf $i*.tar.* > /dev/null
		# get dirname
		for j in $(find ./ -maxdepth 1 -type d | xargs)
		do 
	    dirname="`echo $j | cut -d '/' -f2`"    
	    if [[ "$dirname" == *$i* ]] ;then
	    	break;
	    fi
		done
		#
		if [[ "$dirname" != *$i* ]] ;then
    	ERR [$FUNCNAME-$LINENO] "dir $dirname is not exsit..."
    	exit 1
    fi
    LOG "dirname is: $dirname"

		#
		CMD [$FUNCNAME-$LINENO] "./make_$i.sh $action $arch $soc $dirname"
		./make_$i.sh $language $action $arch $soc $dirname $clibs		# $language $action $arch $soc $dirname $clibs
		cd $CUR_DIR
	done
	# end loop
elif [[ "$action" == "clean" || "$action" == "uninstall" ]] ;then
	# for loop
	for i in $dependences 
	do 
		CMD [$FUNCNAME-$LINENO] $i;
		if [ "$i" != "libnl" ] \
		&& [ "$i" != "openssl" ] \
		&& [ "$i" != "libtommath" ] \
		&& [ "$i" != "expat" ] \
		&& [ "$i" != "dbus" ] \
		&& [ "$i" != "gettext" ] \
		&& [ "$i" != "zlib" ] \
		&& [ "$i" != "libffi" ] \
		&& [ "$i" != "glib" ] \
		&& [ "$i" != "wireless_tools" ] \
		&& [ "$i" != "ffmpeg" ] \
		&& [ "$i" != "wpa_supplicant" ] \
		&& [ "$i" != "mxml" ] \
		&& [ "$i" != "parson_json" ] \
		&& [ "$i" != "ncurses" ] \
		&& [ "$i" != "gdb" ] \
		&& [ "$i" != "libxml2" ] ;then
			 ERR [$FUNCNAME-$LINENO] "dependence: $i unsupport..."
			 exit 1
		fi
		cd $CUR_DIR/Dependencies		 
		# delete old dir
		for j in $(find ./ -maxdepth 1 -type d)
		do 
	    dirname="$(basename $j)"    
	    if [[ "$dirname" == *$i* ]] ;then
	    	LOG $dirname
	    	WARN [$FUNCNAME-$LINENO] "rm -fr $dirname"
	    	rm -fr $dirname
	    	break;
	    fi
		done
		#
	done
	# end loop
elif [[ "$action" == "install" ]] ;then
	WARN [$FUNCNAME-$LINENO] "action: $action"
else
	#
	ERR [$FUNCNAME-$LINENO] "unknow action: $action"
	exit 1
fi




######################################################################
# currnet dir
######################################################################
cd $CUR_DIR

######################################################################
# do work
######################################################################
if [ "$unit" == "wpa_supplicant" ] ;then
	LOG "unit is : wpa_supplicant "
	LOG "nothing to do.... exit!"
	
	exit 0
	
elif [ "$unit" == "qt" ] ;then
	ERR [$FUNCNAME-$LINENO] "unsupport..."
	exit 0
elif [ "$unit" == "none" ] ;then
	LOG "unit is : none "
	LOG "nothing to do.... exit!"
	
	exit 0
else
	ERR [$FUNCNAME-$LINENO] "unknow command..."
	exit 0
fi	
