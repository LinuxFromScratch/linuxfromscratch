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


if [ "$clibs" != "glibc" ] ;then
	 ERR [$FUNCNAME-$LINENO] "glib need glibc,so you must setting 'clibs' to glibc ..."
	 exit 1
fi

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
	
	export PKG_CONFIG_PATH=$HOME/linuxfromscratch/target/$1/$2/$3/$4/lib/pkgconfig
	
	# TARGET 
	if [ "$3" == "arm" ] ;then	
		options="--enable-silent-rules --enable-static --enable-shared --with-pcre=internal --disable-gtk-doc-html --disable-man "
		cache_options="glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=no ac_cv_func_posix_getgrgid_r=no"
		./configure ${options} ${cache_options} --host=${ARM_HOSTNAME}  \
		--prefix=$HOME/linuxfromscratch/target/$1/$2/$3/$4 \
		CC="${ARM_TOOL_CHAINS_PREFIX}${LINUX_COMPILER}" \
		CFLAGS="-fPIC -Wall -Wno-format -fno-strict-aliasing -O2 -Wno-format-nonliteral -Wno-format-overflow  -Wno-format-security -I$HOME/linuxfromscratch/target/$1/$2/$3/$4/include" \
		LDFLAGS="-L$HOME/linuxfromscratch/target/$1/$2/$3/$4/lib" 	
	elif [ "$3" == "x86" ] ;then		
		options="--enable-silent-rules --enable-static --enable-shared --with-pcre=internal --disable-gtk-doc-html --disable-man "
		cache_options="glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=no ac_cv_func_posix_getgrgid_r=no"
		./configure ${options} ${cache_options} \
		--prefix=$HOME/linuxfromscratch/target/$1/$2/$3/$4 \
		CC="gcc" \
		CFLAGS="-fPIC -Wall -Wno-format -fno-strict-aliasing -O2 -Wno-format-nonliteral -Wno-format-overflow  -Wno-format-security -I$HOME/linuxfromscratch/target/$1/$2/$3/$4/include" \
		LDFLAGS="-L$HOME/linuxfromscratch/target/$1/$2/$3/$4/lib" 	
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
	make -j8 && make install
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
