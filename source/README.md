

1.�������
	[clibs]: ��Ҫ����������C��. C���ѡȡ�����˽�����빤��������.
	clibs options: [uclibc/glibc]
	uclibc : �����C��,�����Դ�ȽϽ��ŵ�Ƕ��ʽϵͳ.����֧��glib��������glibc�Ŀ�. ��glibc��û�б�Ȼ����ϵ.
	
	[unit] 
	unit options: [wpa_supplicant/qt/none]
	wpa_supplicant: �������ô���
	qt: Ƕ��ʽ����,���ڴ�����̫��,�����ڴ˹��̱���.
	none: �˵�Ԫû��Ŀ�����,һ��ʹ���������������ɿ�,�����ǿ�ִ�г���.
	
	
	[action] 
	action options: [make/clean/install/uninstall]
	������붯��.
	
	[arch] 
	arch options: [arm/x86/mips]
	�ܹ�
	
	[soc] 
	soc options: [goke/hi3518e/hi3518ev200]
	оƬ����.
	
	[dependence]
	dependence options: [libnl/openssl/libtommath/expat/dbus/gettext/zlib/libffi/glib]
	������.

2.����
	
	2.1 wpa_supplicant ����
		  wpa_supplicant �ж���������ʽ,�����������defconfig�ļ�,������ѡ������Ҫ�����Ŀ�.
		  �����ڲü���ѡ��.������Ҫ����3��������ʽ.
		  
		  defconfig �ļ�������������.
		  # Select TLS implementation
			# openssl = OpenSSL (default)
			# gnutls = GnuTLS
			# internal = Internal TLSv1 implementation (experimental)
			# none = Empty template
			#CONFIG_TLS=openssl
			
			(1) ʹ��openSSL
					������ openssl��. ���� CONFIG_TLS=openssl (Ĭ�Ͼ���openssl)
					
			(2) internel
					������ libtommath��. ���� CONFIG_TLS=internal (Ĭ�Ͼ���openssl)
			
			(3) libnl
					Ϊ��֧�� IEEE 802.11 Э��,��Ҫ���� 
					CONFIG_DRIVER_NL80211=y
					CONFIG_IEEE8021X_EAPOL=y
					���� libnl ��.
			
			ע��: (1)��(2)ѡ���, (3)ѡ��Ƚ϶���
			
	2.2 none 
			����������ֿ�.

3.������
	
	3.1 dbus ��
			dbus �� ������ �����,��ȻҲ��ѡ,��Ҫ������Ҫ���� configure ����
			(1) ֻ���� expat
			
			(2) ���� glib��
	
	3.2 glib ��
			�߰汾glib��(�߰汾���Ŵ�glib-2.30.3��ʼ),���� gettext ��zlib ��libffi ��������.
			�Ͱ汾glib��,���� dbus��zlib��.
			���ڸ߰汾�����������ļ�̫��,��������ѡ��Ͱ汾��glib��,����Ҳ�պù���.
			�Ͱ汾ʹ���� glib-2.28.7.tar.bz2 
			
			(1) �汾����
			�� glib-2.28.7.tar.bz2 ���µ� glib-2.40.2.tar.xz
			glib-2.40.2 ��Ҫ�����ⲿ�� libffi ��zlib
			
			>>> ubuntu�汾��Ϣ: Linux netview 4.4.0-104-generic #127~14.04.1-Ubuntu SMP Mon Dec 11 12:44:57 UTC 2017 i686 i686 i686 GNU/Linux
			
	
	3.3 ffmpeg ��
			
	
	
