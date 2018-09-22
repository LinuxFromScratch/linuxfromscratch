

1.命令参数
	[clibs]: 需要编译依赖的C库. C库的选取决定了交叉编译工具链类型.
	clibs options: [uclibc/glibc]
	uclibc : 精简的C库,针对资源比较紧张的嵌入式系统.但不支持glib等依赖于glibc的库. 与glibc库没有必然的联系.
	
	[unit] 
	unit options: [wpa_supplicant/qt/none]
	wpa_supplicant: 网络配置代码
	qt: 嵌入式界面,由于代码量太大,放弃在此工程保存.
	none: 此单元没有目标程序,一般使用来单独编译若干库,而不是可执行程序.
	
	
	[action] 
	action options: [make/clean/install/uninstall]
	具体编译动作.
	
	[arch] 
	arch options: [arm/x86/mips]
	架构
	
	[soc] 
	soc options: [goke/hi3518e/hi3518ev200]
	芯片类型.
	
	[dependence]
	dependence options: [libnl/openssl/libtommath/expat/dbus/gettext/zlib/libffi/glib]
	依赖库.

2.工程
	
	2.1 wpa_supplicant 工程
		  wpa_supplicant 有多种依赖方式,具体可以配置defconfig文件,来进行选择所需要依赖的库.
		  方便于裁剪及选择.这里主要介绍3种依赖方式.
		  
		  defconfig 文件配置内容如下.
		  # Select TLS implementation
			# openssl = OpenSSL (default)
			# gnutls = GnuTLS
			# internal = Internal TLSv1 implementation (experimental)
			# none = Empty template
			#CONFIG_TLS=openssl
			
			(1) 使用openSSL
					依赖于 openssl库. 配置 CONFIG_TLS=openssl (默认就是openssl)
					
			(2) internel
					依赖于 libtommath库. 配置 CONFIG_TLS=internal (默认就是openssl)
			
			(3) libnl
					为了支持 IEEE 802.11 协议,需要配置 
					CONFIG_DRIVER_NL80211=y
					CONFIG_IEEE8021X_EAPOL=y
					依赖 libnl 库.
			
			注意: (1)与(2)选项互斥, (3)选项比较独立
			
	2.2 none 
			单独编译各种库.

3.库依赖
	
	3.1 dbus 库
			dbus 库 依赖于 多个库,当然也可选,需要根据需要配置 configure 参数
			(1) 只依赖 expat
			
			(2) 依赖 glib库
	
	3.2 glib 库
			高版本glib库(高版本库大概从glib-2.30.3开始),依赖 gettext 、zlib 、libffi 等三个库.
			低版本glib库,依赖 dbus、zlib库.
			由于高版本库编译出来库文件太大,所以我们选择低版本的glib库,功能也刚好够用.
			低版本使用是 glib-2.28.7.tar.bz2 
			
			(1) 版本更新
			从 glib-2.28.7.tar.bz2 更新到 glib-2.40.2.tar.xz
			glib-2.40.2 需要依赖外部库 libffi 、zlib
			
			>>> ubuntu版本信息: Linux netview 4.4.0-104-generic #127~14.04.1-Ubuntu SMP Mon Dec 11 12:44:57 UTC 2017 i686 i686 i686 GNU/Linux
			
	
	3.3 ffmpeg 库
			
	
	
