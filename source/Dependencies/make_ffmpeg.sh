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
	#COMMON		
	ENV_VAR_UNSET
	
	# TARGET 
	if [ "$3" == "arm" ] ;then	
		standard_options="--prefix=$HOME/linuxfromscratch/target/$1/$2/$3/$4"
		licensing_options=""
		configuration_options="--enable-static --enable-shared"
		program_options=""
		documentation_options="--disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages"
		component_options=""
		individual_component_options=""
		external_library_support=""
		toolchain_options="--enable-cross-compile --arch=$2 --target-os=linux  --enable-pic --cross-prefix=${ARM_TOOL_CHAINS_PREFIX}  --pkg-config=pkg-config"
		advanced_options=""
		optimization_options=""
		developer_options=""

		./configure ${standard_options} ${licensing_options} ${configuration_options} ${program_options} ${documentation_options} \
		${component_options} ${individual_component_options} ${external_library_support} ${toolchain_options} \
		${advanced_options} ${optimization_options} ${developer_options}
		
	elif [ "$3" == "x86" ] ;then		
		CMD "[$FUNCNAME-$LINENO]" "cd cmake"
		cd cmake
		CMD "[$FUNCNAME-$LINENO]" "cmake ."
		cmake .
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
	make && make install
}

#$1 : dirname
do_clean()
{
	CMD "[$FUNCNAME-$LINENO]" "rm -fr $CUR_DIR/$1"
	rm -fr $CUR_DIR/$1
}

do_install()
{
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
	do_platform_config $language $clibs $arch $soc # language clibs arch soc
  # 
	do_make
elif [ "$action" == "clean" ] ;then
	do_clean $dirname
elif [ "$action" == "install" ] ;then
	# 
	do_platform_config $language $clibs $arch $soc # language clibs arch soc
  # 
	do_install
elif [ "$action" == "uninstall" ] ;then
	do_uninstall $dirname
else
	ERR [$FUNCNAME-$LINENO] "unknow command"
	exit 0
fi	
