#by leon 2017-11-21

source ../common.sh

CUR_DIR=$PWD

if [ $# -lt 6 ];then
	dependencies_info  $0
	exit 1
fi

CMD [$FUNCNAME-$LINENO] "$0 language=$1 action=$2 arch=$3 soc=$4 dirname=$5 clibs=$6"

language=$1
action=$2 
arch=$3 
soc=$4 
dirname=$5 
clibs=$6

######################################################################
# assertion
######################################################################
#$1: language
#$2: action
#$3: arch
#$4: soc
#$5: clibs
dependencies_assert $language $action $arch $soc $clibs


######################################################################
# do XXX config
######################################################################
#$1: language
#$2: clibs
#$3: $arch
#$4: $soc
#$5: $dirname
do_platform_config()
{
	#COMMON
	#defconfig
	: > $3config
	echo "CONFIG_DRIVER_WEXT=y"      >> $3config
	echo "CONFIG_DRIVER_WIRED=y"     >> $3config
	echo "CONFIG_EAP_MD5=y"          >> $3config
	echo "CONFIG_EAP_MSCHAPV2=y"     >> $3config
	echo "CONFIG_EAP_TLS=y"          >> $3config
	echo "CONFIG_EAP_PEAP=y"         >> $3config
	echo "CONFIG_EAP_TTLS=y"         >> $3config
	echo "CONFIG_EAP_GTC=y"          >> $3config
	echo "CONFIG_EAP_OTP=y"          >> $3config
	echo "CONFIG_EAP_LEAP=y"         >> $3config
	echo "CONFIG_PKCS12=y"           >> $3config
	echo "CONFIG_SMARTCARD=y"        >> $3config
	echo "CONFIG_BACKEND=file"       >> $3config
	echo "CONFIG_PEERKEY=y"          >> $3config
	echo "CONFIG_CTRL_IFACE=y"       >> $3config
	
	# 依赖库 CONFIG_TLS 为互斥关系,只能配置一个.
	echo "CONFIG_TLS=internal" >> $3config
	#echo "CONFIG_TLS=openssl" >> $3config
	
	#echo "CONFIG_DRIVER_NL80211=y"   >> $3config
	#echo "CONFIG_IEEE8021X_EAPOL=y"  >> $3config
	
	# TARGET 
	if [ "$3" == "arm" ] ;then		
		# compiler config
		ENV_VAR_UNSET
		#
		export DESTDIR=""
		export LIBDIR="$HOME/linuxfromscratch/target/$1/$2/$3/$4/lib"
		export INCDIR="$HOME/linuxfromscratch/target/$1/$2/$3/$4/include"
		export BINDIR="$HOME/linuxfromscratch/target/$1/$2/$3/$4/bin"
		export PKG_CONFIG="pkg-config"
		export CC="${ARM_TOOL_CHAINS_PREFIX}${LINUX_COMPILER}"
		export CFLAGS="-MMD -O2 -Wall -I $INCDIR"
		export LDFLAGS="-L $LIBDIR"
	elif [ "$3" == "x86" ] ;then
		# compiler config
		export LIBDIR="$HOME/linuxfromscratch/target/$1/$2/$3/$4/lib"
		export INCDIR="$HOME/linuxfromscratch/target/$1/$2/$3/$4/include"
		export BINDIR="$HOME/linuxfromscratch/target/$1/$2/$3/$4/bin"
		export PKG_CONFIG="pkg-config"
		export CC=${LINUX_COMPILER}
		export CFLAGS="-MMD -O2 -Wall -I $INCDIR"
		export LDFLAGS="-L $LIBDIR"
	elif [ "$3" == "mips" ] ;then
		WARN [$FUNCNAME-$LINENO] "unsupport arch: $3"
		exit 1
	else
		ERR [$FUNCNAME-$LINENO] "unknow arch"
		exit 1
	fi	
	
	#OTHER
	echo "CONFIG_BUILD_WPA_CLIENT_SO=y" >> $3config
}

######################################################################
# fuctions
######################################################################
#$1: arch
do_make()
{
	cd wpa_supplicant
	cp ../$1config .config
	make && make install
}

#$1 : dirname
do_clean()
{
	CMD "[$FUNCNAME-$LINENO]" "rm -fr $CUR_DIR/$1"
	rm -fr $CUR_DIR/$1
}

#$1: arch
do_install()
{
	cd wpa_supplicant
	cp ../$1config .config
	make && make install
}

#$1 : dirname
do_uninstall()
{
	CMD "[$FUNCNAME-$LINENO]" "rm -fr $CUR_DIR/$1"
	rm -fr $CUR_DIR/$1
}

#
cd $CUR_DIR/$dirname

#work
CMD [$FUNCNAME-$LINENO] "$CUR_DIR: $language action=$action arch=$arch soc=$soc dirname=$dirname clibs=$clibs"
if [ "$action" == "make" ] ;then
	# 
	do_platform_config $language $clibs $arch $soc $dirname # language clibs arch soc dirname
  # 
	do_make $arch
elif [ "$action" == "clean" ] ;then
	do_clean $dirname
elif [ "$action" == "install" ] ;then
	# 
	do_platform_config $language $clibs $arch $soc $dirname # language clibs arch soc dirname
  # 
	do_install $arch
elif [ "$action" == "uninstall" ] ;then
	do_uninstall $dirname
else
	ERR [$FUNCNAME-$LINENO] "unknow command"
	exit 0
fi	
