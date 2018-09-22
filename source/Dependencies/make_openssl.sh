#by leon 2017-11-22

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
#$1 : language
#$2 : clibs
#$3 : arch
#$4 : soc
do_platform_config()
{
	#UNSET ENV
	ENV_VAR_UNSET
	#COMMON		
	./Configure --enable-static --enable-shared linux-generic32 shared no-async no-asm -DL_ENDIAN \
	--prefix=$HOME/linuxfromscratch/target/$1/$2/$3/$4	 \
	--openssldir=$HOME/linuxfromscratch/target/$1/$2/$3/$4
	# TARGET 
	if [ "$3" == "arm" ] ;then			
		sed -i '/CROSS_COMPILE/s/CROSS_COMPILE=/CROSS_COMPILE?=/' Makefile
		export CROSS_COMPILE="${ARM_TOOL_CHAINS_PREFIX}"
		export PROCESSOR="ARM"
		export CC="${ARM_TOOL_CHAINS_PREFIX}${LINUX_COMPILER}"
	elif [ "$3" == "x86" ] ;then		
		sed 's/CROSS_COMPILE=/CROSS_COMPILE?=/g' -i Makefile
		export CROSS_COMPILE=
		export PROCESSOR="I386"
		export CC="${LINUX_COMPILER}"
	else
		ERR [$FUNCNAME-$LINENO] "unsupport target: $3"
		exit 1
	fi	
	
	#OTHER
	
}

######################################################################
# fuctions
######################################################################
#
do_make()
{
	make && make install_sw
}

#$1 : dirname
do_clean()
{
	CMD "[$FUNCNAME-$LINENO]" "rm -fr $CUR_DIR/$1"
	rm -fr $CUR_DIR/$1
}

do_install()
{
	make && make install_sw
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
CMD [$FUNCNAME-$LINENO] "$CUR_DIR: language=$language action=$action arch=$arch soc=$soc dirname=$dirname clibs=$clibs"
if [ "$action" == "make" ] ;then
	# 
	do_platform_config $language $clibs $arch $soc # language clibs arch soc
  # 
	do_make
elif [ "$action" == "clean" ] ;then
	do_clean 
elif [ "$action" == "install" ] ;then
	# 
	do_platform_config $language $clibs $arch $soc # language clibs arch soc
  # 
	do_install
elif [ "$action" == "uninstall" ] ;then
	do_uninstall
else
	ERR [$FUNCNAME-$LINENO] "unknow command"
	exit 0
fi	
