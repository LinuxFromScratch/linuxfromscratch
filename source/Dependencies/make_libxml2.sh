#by leon 2017-11-22

source ../common.sh

CUR_DIR=$PWD

if [ $# -lt 5 ];then
	ERR [$FUNCNAME-$LINENO] "usage: $0 [action] [arch] [soc] [dirname] [clibs]"
	CMD [$FUNCNAME-$LINENO] "action options: [make/clean/install/uninstall]"
	CMD [$FUNCNAME-$LINENO] "arch options: [arm/x86/mips]"
	CMD [$FUNCNAME-$LINENO] "soc options: [goke/hi3518e/hi3518ev200]"
	CMD [$FUNCNAME-$LINENO] "clibs options: [uclibc/glibc]"
	exit 1
fi

CMD [$FUNCNAME-$LINENO] "$0 action=$1 arch=$2 soc=$3 dirname=$4 clibs=$5"

action=$1 
arch=$2 
soc=$3 
dirname=$4 
clibs=$5

######################################################################
# do XXX config
######################################################################
#$1 : target
do_platform_config()
{
	#COMMON		
	
	# TARGET 
	if [ "$1" == "arm" ] ;then	
		WARN [$FUNCNAME-$LINENO] "unsupport target: $1"
		exit 1
	elif [ "$1" == "x86" ] ;then		
		WARN [$FUNCNAME-$LINENO] "unsupport target: $1"
		exit 1
	else
		ERR [$FUNCNAME-$LINENO] "unsupport target: $1"
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
cd $CUR_DIR/$3

#work
CMD [$FUNCNAME-$LINENO] "$CUR_DIR: $1 $2 $3"
if [ "$1" == "make" ] ;then
	# 
	do_platform_config $2
  # 
	do_make
elif [ "$1" == "clean" ] ;then
	do_clean 
elif [ "$1" == "install" ] ;then
	# 
	do_platform_config $2
  # 
	do_install
elif [ "$1" == "uninstall" ] ;then
	do_uninstall
else
	ERR [$FUNCNAME-$LINENO] "unknow command"
	exit 0
fi	
