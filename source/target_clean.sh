
source ./common.sh

CUR_DIR=$PWD

if [ $# -lt 4 ];then
	ERR [$FUNCNAME-$LINENO] "usage: $0 [language] [clibs] [arch] [soc]"
	CMD [$FUNCNAME-$LINENO] "language options: [c/cpp]"
	CMD [$FUNCNAME-$LINENO] "clibs options: [uclibc/glibc]"
	CMD [$FUNCNAME-$LINENO] "arch options: [arm/x86/mips]"
	CMD [$FUNCNAME-$LINENO] "soc options: [goke/hi3518e/hi3518ev200/xilink]"
	exit 1
fi

CMD [$FUNCNAME-$LINENO] "$0 language=$1 clibs=$2 arch=$3 soc=$4 "


language=$1
clibs=$2 
arch=$3 
soc=$4 

if [[ "$language" != "c" ]] \
&& [[ "$language" != "cpp" ]] ;then
	 ERR [$FUNCNAME-$LINENO] "language: $language unsupport..."
	 exit 1
fi

LOG "clibs=$clibs"
if [ "$clibs" != "uclibc" ] \
&& [ "$clibs" != "glibc" ] ;then
	 ERR [$FUNCNAME-$LINENO] "clibs: $clibs unsupport..."
	 exit 1
fi

LOG "arch=$arch"
if [ "$arch" != "arm" ] \
&& [ "$arch" != "x86" ] \
&& [ "$arch" != "mips" ] ;then
	 ERR [$FUNCNAME-$LINENO] "arch: $arch unsupport..."
	 exit 1
fi

if [[ "$soc" != "goke" ]] \
&& [[ "$soc" != "hi3518e" ]] \
&& [[ "$soc" != "hi3518ev200" ]] \
&& [[ "$soc" != "xilink" ]] ;then
	ERR [$FUNCNAME-$LINENO] "soc: $soc unsupport..."
	exit 1	 
fi

#$1 : language
#$2 : clibs
#$3 : arch
#$4 : soc
do_remove_target_file()
{
	CMD [$FUNCNAME-$LINENO] "do remove [language]:$1 [clibs]: $2 [arch]: $3 [soc]:$4"
	rm -f *.bak
	rm -f `find -name *.bak`
	rm -fr ../target/$1/$2/$3/$4/*
}


if [[ "$arch" == "arm" || "$arch" == "x86" || "$arch" == "mips" ]];then
	
	if [[ "$soc" == "goke" || "$soc" == "hi3518e" || "$soc" == "hi3518ev200" || "$soc" == "xilink" ]] ;then
		do_remove_target_file $language $clibs $arch $soc
	else
		ERR [$FUNCNAME-$LINENO] "soc: $soc unsupport..."
	fi
else
	ERR [$FUNCNAME-$LINENO] "arch: $arch unsupport..."
	exit 1
fi


