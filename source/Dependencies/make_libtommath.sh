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
	sed -i 's/DESTDIR=/DESTDIR?=/g' makefile
	sed -i 's/LIBPATH=/LIBPATH?=/g' makefile
	sed -i 's/INCPATH=/INCPATH?=/g' makefile
	sed -i 's/DATAPATH=/DATAPATH?=/g' makefile
	
	sed -i '/default/s/libtommath.a/libtommath.a libtommath.so/' makefile
	sed -i '/ifndef LIBNAME/i\DLIBNAME=libtommath.so' makefile
	sed -i '/$(LIBNAME):  $(OBJECTS)/i\$(DLIBNAME):  $(OBJECTS)' makefile
	sed -i '/$(LIBNAME):  $(OBJECTS)/i\\t$(CC) -shared -o $@ $^' makefile
	sed -i '/install -g $(GROUP) -o $(USER) $(LIBNAME) $(DESTDIR)$(LIBPATH)/a\\tinstall -g $(GROUP) -o $(USER) $(DLIBNAME) $(DESTDIR)$(LIBPATH)' makefile
	
	#defconfig
	export INSTALL_GROUP="`whoami`"
	export INSTALL_USER="`whoami`"
	export LIBNAME="libtommath.a"			
	
	#
	ENV_VAR_UNSET
	
	# TARGET 
	if [ "$3" == "arm" ] ;then	
		# compiler config		
		export DESTDIR="$HOME/linuxfromscratch/target/$1/$2/$3/$4/"
		export LIBPATH="lib"
		export INCPATH="include"
		export BINPATH="bin"
		export DATAPATH="share/doc/libtommath/pdf"
		export CC="${ARM_TOOL_CHAINS_PREFIX}${LINUX_COMPILER}"
		export CFLAGS="-MMD -O2 -Wall"	
	elif [ "$3" == "x86" ] ;then
		# compiler config		
		export DESTDIR="$HOME/linuxfromscratch/target/$1/$2/$3/$4/"
		export LIBPATH="lib"
		export INCPATH="include"
		export BINPATH="bin"
		export DATAPATH="share/doc/libtommath/pdf"
		export CC=${LINUX_COMPILER}
		export CFLAGS="-MMD -O2 -Wall"
	elif [ "$3" == "mips" ] ;then
		WARN [$FUNCNAME-$LINENO] "unsupport target: $3"
		exit 1
	else
		ERR [$FUNCNAME-$LINENO] "unknow target"
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
CMD [$FUNCNAME-$LINENO] "$CUR_DIR: language=$language action=$action arch=$arch soc=$soc dirname=$dirname clibs=$clibs"
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


