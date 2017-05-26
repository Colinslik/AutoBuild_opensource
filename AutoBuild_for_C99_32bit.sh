#!/bin/bash

#=====Argument setup=====

if [ -z "$1" ]; then
  Dest="$(pwd)/lib"
else
  Dest="$1/lib"
fi

Container_ID=ubuntu32

Git_ID=XXXXX

Git_Passwd=XXXXX

Local_IP=XXX.XXX.XXX.XXX

Local_User=XXX

Local_Passwd=XXX

#=======================

mkdir -p $Dest

echo "Output Path:$Dest"

#=====get Current image ID=====
IMAGE_ID=$(docker build -t orbweb/$Container_ID:v1 /home/colin/dockerfiles/Ubuntu_32bit/ 2>/dev/null | awk '/Successfully built/{print $NF}')

echo $IMAGE_ID

#=====get Base image ID=====
ORI_ID=$(docker images -q ioft/i386-ubuntu)

echo $ORI_ID

#=====create docker in background=====
docker run -id --name $Container_ID orbweb/$Container_ID:v1 /bin/bash

#docker start $Container_ID

#=====clone all necessary parts=====
docker exec -e Git_ID=$Git_ID -e Git_Passwd=$Git_Passwd $Container_ID bash -c 'cd /home/colin/git_home ; \
git clone http://$Git_ID:$Git_Passwd@git.XXX.com/XXX/nattraversal-client.git ; \
git clone http://$Git_ID:$Git_Passwd@git.XXX.com/XXX/libuv.git ; \
wget https://nchc.dl.sourceforge.net/project/axtls/2.1.3/axTLS-2.1.3.tar.gz ; \
tar -zxvf axTLS-2.1.3.tar.gz ; \
git clone https://github.com/curl/curl.git
'

#=====change branch=====
docker exec $Container_ID bash -c 'cd /home/colin/git_home/nattraversal-client ; git checkout pure-c99
'

#=====build open UV=====
docker exec -e Local_IP=$Local_IP -e Local_User=$Local_User -e Local_Passwd=$Local_Passwd -e Dest=$Dest $Container_ID bash -c 'cd /home/colin/git_home/libuv ; \
sh autogen.sh ; export CFLAGS="-fPIC" ; ./configure ; make ; cp /home/colin/git_home/libuv/.libs/libuv.a /home/colin/git_home/nattraversal-client/3rd-party/libuv/lib/unix/x86 ; \
expect -c "  
   set timeout 1
   spawn scp /home/colin/git_home/libuv/.libs/libuv.a $Local_User@$Local_IP:$Dest
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   exit
"'

#=====Keep for 32bit CPP code=====
: <<'END'
#=====build jsonCpp=====
docker exec -e Local_IP=$Local_IP -e Local_User=$Local_User -e Local_Passwd=$Local_Passwd -e Dest=$Dest $Container_ID bash -c 'cd /home/colin/git_home/jsoncpp ; \
git checkout 0.7.1 ; mkdir -p /home/colin/git_home/jsoncpp/output ; cd /home/colin/git_home/jsoncpp/output ; cmake ../ ; make ; \
cp /home/colin/git_home/jsoncpp/output/lib/libjsoncpp.a /home/colin/git_home/nattraversal-client/3rd-party/jsoncpp/lib/linux/x86` ; \
expect -c "
   set timeout 1
   spawn scp /home/colin/git_home/jsoncpp/output/lib/libjsoncpp.a $Local_User@$Local_IP:$Dest
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   exit
"'

#=====build libz=====
docker exec -e Local_IP=$Local_IP -e Local_User=$Local_User -e Local_Passwd=$Local_Passwd -e Dest=$Dest $Container_ID bash -c 'cd /home/colin/git_home/zlib ; \
./configure ; make ; make install ; cp /home/colin/git_home/zlib/libz.a /home/colin/git_home/nattraversal-client/3rd-party/libcURL/unix/x86 ; \
expect -c "
   set timeout 1
   spawn scp /home/colin/git_home/zlib/libz.a $Local_User@$Local_IP:$Dest
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   exit
"'

#=====build open ssl=====
docker exec -e Local_IP=$Local_IP -e Local_User=$Local_User -e Local_Passwd=$Local_Passwd -e Dest=$Dest $Container_ID bash -c 'cd /home/colin/git_home/openssl ; \
./config ; make ; make install ; \
cp /home/colin/git_home/openssl/libssl.a /home/colin/git_home/nattraversal-client/3rd-party/libcURL/unix/x86 ; \
cp /home/colin/git_home/openssl/libcrypto.a /home/colin/git_home/nattraversal-client/3rd-party/libcURL/unix/x86 ; \
expect -c "
   set timeout 1
   spawn scp /home/colin/git_home/openssl/libssl.a $Local_User@$Local_IP:$Dest
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   spawn scp /home/colin/git_home/openssl/libcrypto.a $Local_User@$Local_IP:$Dest
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   exit
"'
END

#==========

#=====create axTLS config files=====
echo "/*
 * Automatically generated header file: don't edit
 */

#define HAVE_DOT_CONFIG 1
#define CONFIG_PLATFORM_LINUX 1
#undef CONFIG_PLATFORM_CYGWIN
#undef CONFIG_PLATFORM_WIN32

/*
 * General Configuration
 */
#define PREFIX \"/usr/local\"
#undef CONFIG_DEBUG
#undef CONFIG_STRIP_UNWANTED_SECTIONS
#undef CONFIG_VISUAL_STUDIO_7_0
#undef CONFIG_VISUAL_STUDIO_8_0
#undef CONFIG_VISUAL_STUDIO_10_0
#define CONFIG_VISUAL_STUDIO_7_0_BASE \"\"
#define CONFIG_VISUAL_STUDIO_8_0_BASE \"\"
#define CONFIG_VISUAL_STUDIO_10_0_BASE \"\"
#define CONFIG_EXTRA_CFLAGS_OPTIONS \"\"
#define CONFIG_EXTRA_LDFLAGS_OPTIONS \"\"

/*
 * SSL Library
 */
#undef CONFIG_SSL_SERVER_ONLY
#undef CONFIG_SSL_CERT_VERIFICATION
#undef CONFIG_SSL_ENABLE_CLIENT
#define CONFIG_SSL_FULL_MODE 1
#undef CONFIG_SSL_SKELETON_MODE
#undef CONFIG_SSL_PROT_LOW
#define CONFIG_SSL_PROT_MEDIUM 1
#undef CONFIG_SSL_PROT_HIGH
#define CONFIG_SSL_USE_DEFAULT_KEY 1
#define CONFIG_SSL_PRIVATE_KEY_LOCATION \"\"
#define CONFIG_SSL_PRIVATE_KEY_PASSWORD \"\"
#define CONFIG_SSL_X509_CERT_LOCATION \"\"
#undef CONFIG_SSL_GENERATE_X509_CERT
#define CONFIG_SSL_X509_COMMON_NAME \"\"
#define CONFIG_SSL_X509_ORGANIZATION_NAME \"\"
#define CONFIG_SSL_X509_ORGANIZATION_UNIT_NAME \"\"
#undef CONFIG_SSL_ENABLE_V23_HANDSHAKE
#define CONFIG_SSL_HAS_PEM 1
#define CONFIG_SSL_USE_PKCS12 1
#define CONFIG_SSL_EXPIRY_TIME 24
#define CONFIG_X509_MAX_CA_CERTS 150
#define CONFIG_SSL_MAX_CERTS 3
#undef CONFIG_SSL_CTX_MUTEXING
#define CONFIG_USE_DEV_URANDOM 1
#undef CONFIG_WIN32_USE_CRYPTO_LIB
#undef CONFIG_OPENSSL_COMPATIBLE
#undef CONFIG_PERFORMANCE_TESTING
#undef CONFIG_SSL_TEST
#undef CONFIG_AXTLSWRAP
#undef CONFIG_AXHTTPD
#undef CONFIG_HTTP_STATIC_BUILD
#define CONFIG_HTTP_PORT 
#define CONFIG_HTTP_HTTPS_PORT 
#define CONFIG_HTTP_SESSION_CACHE_SIZE 
#define CONFIG_HTTP_WEBROOT \"\"
#define CONFIG_HTTP_TIMEOUT 
#undef CONFIG_HTTP_HAS_CGI
#define CONFIG_HTTP_CGI_EXTENSIONS \"\"
#undef CONFIG_HTTP_ENABLE_LUA
#define CONFIG_HTTP_LUA_PREFIX \"\"
#undef CONFIG_HTTP_BUILD_LUA
#define CONFIG_HTTP_CGI_LAUNCHER \"\"
#undef CONFIG_HTTP_DIRECTORIES
#undef CONFIG_HTTP_HAS_AUTHORIZATION
#undef CONFIG_HTTP_HAS_IPV6
#undef CONFIG_HTTP_ENABLE_DIFFERENT_USER
#define CONFIG_HTTP_USER \"\"
#undef CONFIG_HTTP_VERBOSE
#undef CONFIG_HTTP_IS_DAEMON

/*
 * Language Bindings
 */
#undef CONFIG_BINDINGS
#undef CONFIG_CSHARP_BINDINGS
#undef CONFIG_VBNET_BINDINGS
#define CONFIG_DOT_NET_FRAMEWORK_BASE \"\"
#undef CONFIG_JAVA_BINDINGS
#define CONFIG_JAVA_HOME \"\"
#undef CONFIG_PERL_BINDINGS
#define CONFIG_PERL_CORE \"\"
#define CONFIG_PERL_LIB \"\"
#undef CONFIG_LUA_BINDINGS
#define CONFIG_LUA_CORE \"\"

/*
 * Samples
 */
#undef CONFIG_SAMPLES
#undef CONFIG_C_SAMPLES
#undef CONFIG_CSHARP_SAMPLES
#undef CONFIG_VBNET_SAMPLES
#undef CONFIG_JAVA_SAMPLES
#undef CONFIG_PERL_SAMPLES
#undef CONFIG_LUA_SAMPLES

/*
 * BigInt Options
 */
#undef CONFIG_BIGINT_CLASSICAL
#undef CONFIG_BIGINT_MONTGOMERY
#define CONFIG_BIGINT_BARRETT 1
#define CONFIG_BIGINT_CRT 1
#undef CONFIG_BIGINT_KARATSUBA
#define MUL_KARATSUBA_THRESH 
#define SQU_KARATSUBA_THRESH 
#define CONFIG_BIGINT_SLIDING_WINDOW 1
#define CONFIG_BIGINT_SQUARE 1
#undef CONFIG_BIGINT_CHECK_ON
#define CONFIG_INTEGER_32BIT 1
#undef CONFIG_INTEGER_16BIT
#undef CONFIG_INTEGER_8BIT" > ${Dest}/config.h

echo "#
# Automatically generated make config: don't edit
#
HAVE_DOT_CONFIG=y
CONFIG_PLATFORM_LINUX=y
# CONFIG_PLATFORM_CYGWIN is not set
# CONFIG_PLATFORM_WIN32 is not set

#
# General Configuration
#
PREFIX=\"/usr/local\"
# CONFIG_DEBUG is not set
# CONFIG_STRIP_UNWANTED_SECTIONS is not set
# CONFIG_VISUAL_STUDIO_7_0 is not set
# CONFIG_VISUAL_STUDIO_8_0 is not set
# CONFIG_VISUAL_STUDIO_10_0 is not set
CONFIG_VISUAL_STUDIO_7_0_BASE=\"\"
CONFIG_VISUAL_STUDIO_8_0_BASE=\"\"
CONFIG_VISUAL_STUDIO_10_0_BASE=\"\"
CONFIG_EXTRA_CFLAGS_OPTIONS=\"\"
CONFIG_EXTRA_LDFLAGS_OPTIONS=\"\"

#
# SSL Library
#
# CONFIG_SSL_SERVER_ONLY is not set
# CONFIG_SSL_CERT_VERIFICATION is not set
# CONFIG_SSL_ENABLE_CLIENT is not set
CONFIG_SSL_FULL_MODE=y
# CONFIG_SSL_SKELETON_MODE is not set
# CONFIG_SSL_PROT_LOW is not set
CONFIG_SSL_PROT_MEDIUM=y
# CONFIG_SSL_PROT_HIGH is not set
CONFIG_SSL_USE_DEFAULT_KEY=y
CONFIG_SSL_PRIVATE_KEY_LOCATION=\"\"
CONFIG_SSL_PRIVATE_KEY_PASSWORD=\"\"
CONFIG_SSL_X509_CERT_LOCATION=\"\"
# CONFIG_SSL_GENERATE_X509_CERT is not set
CONFIG_SSL_X509_COMMON_NAME=\"\"
CONFIG_SSL_X509_ORGANIZATION_NAME=\"\"
CONFIG_SSL_X509_ORGANIZATION_UNIT_NAME=\"\"
# CONFIG_SSL_ENABLE_V23_HANDSHAKE is not set
CONFIG_SSL_HAS_PEM=y
CONFIG_SSL_USE_PKCS12=y
CONFIG_SSL_EXPIRY_TIME=24
CONFIG_X509_MAX_CA_CERTS=150
CONFIG_SSL_MAX_CERTS=3
# CONFIG_SSL_CTX_MUTEXING is not set
CONFIG_USE_DEV_URANDOM=y
# CONFIG_WIN32_USE_CRYPTO_LIB is not set
# CONFIG_OPENSSL_COMPATIBLE is not set
# CONFIG_PERFORMANCE_TESTING is not set
# CONFIG_SSL_TEST is not set
# CONFIG_AXTLSWRAP is not set
# CONFIG_AXHTTPD is not set
# CONFIG_HTTP_STATIC_BUILD is not set
CONFIG_HTTP_PORT=0
CONFIG_HTTP_HTTPS_PORT=0
CONFIG_HTTP_SESSION_CACHE_SIZE=0
CONFIG_HTTP_WEBROOT=\"\"
CONFIG_HTTP_TIMEOUT=0
# CONFIG_HTTP_HAS_CGI is not set
CONFIG_HTTP_CGI_EXTENSIONS=\"\"
# CONFIG_HTTP_ENABLE_LUA is not set
CONFIG_HTTP_LUA_PREFIX=\"\"
# CONFIG_HTTP_BUILD_LUA is not set
CONFIG_HTTP_CGI_LAUNCHER=\"\"
# CONFIG_HTTP_DIRECTORIES is not set
# CONFIG_HTTP_HAS_AUTHORIZATION is not set
# CONFIG_HTTP_HAS_IPV6 is not set
# CONFIG_HTTP_ENABLE_DIFFERENT_USER is not set
CONFIG_HTTP_USER=\"\"
# CONFIG_HTTP_VERBOSE is not set
# CONFIG_HTTP_IS_DAEMON is not set

#
# Language Bindings
#
# CONFIG_BINDINGS is not set
# CONFIG_CSHARP_BINDINGS is not set
# CONFIG_VBNET_BINDINGS is not set
CONFIG_DOT_NET_FRAMEWORK_BASE=\"\"
# CONFIG_JAVA_BINDINGS is not set
CONFIG_JAVA_HOME=\"\"
# CONFIG_PERL_BINDINGS is not set
CONFIG_PERL_CORE=\"\"
CONFIG_PERL_LIB=\"\"
# CONFIG_LUA_BINDINGS is not set
CONFIG_LUA_CORE=\"\"

#
# Samples
#
# CONFIG_SAMPLES is not set
# CONFIG_C_SAMPLES is not set
# CONFIG_CSHARP_SAMPLES is not set
# CONFIG_VBNET_SAMPLES is not set
# CONFIG_JAVA_SAMPLES is not set
# CONFIG_PERL_SAMPLES is not set
# CONFIG_LUA_SAMPLES is not set

#
# BigInt Options
#
# CONFIG_BIGINT_CLASSICAL is not set
# CONFIG_BIGINT_MONTGOMERY is not set
CONFIG_BIGINT_BARRETT=y
CONFIG_BIGINT_CRT=y
# CONFIG_BIGINT_KARATSUBA is not set
MUL_KARATSUBA_THRESH=0
SQU_KARATSUBA_THRESH=0
CONFIG_BIGINT_SLIDING_WINDOW=y
CONFIG_BIGINT_SQUARE=y
# CONFIG_BIGINT_CHECK_ON is not set
CONFIG_INTEGER_32BIT=y
# CONFIG_INTEGER_16BIT is not set
# CONFIG_INTEGER_8BIT is not set" > ${Dest}/.config

echo "deps_config := \\
	ssl/BigIntConfig.in \\
	samples/Config.in \\
	bindings/Config.in \\
	httpd/Config.in \\
	ssl/Config.in \\
	config/Config.in

.config include/config.h: \$(deps_config)

\$(deps_config):" > ${Dest}/.config.tmp

#==========

#=====build axTLS=====
docker exec -e Local_IP=$Local_IP -e Local_User=$Local_User -e Local_Passwd=$Local_Passwd -e Dest=$Dest $Container_ID bash -c 'cd /home/colin/git_home/axtls-code ; \
expect -c "
   set timeout 1
   spawn scp $Local_User@$Local_IP:$Dest/config.h /home/colin/git_home/axtls-code/config
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   spawn scp $Local_User@$Local_IP:$Dest/.config /home/colin/git_home/axtls-code/config
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   spawn scp $Local_User@$Local_IP:$Dest/.config.tmp /home/colin/git_home/axtls-code/config
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   exit
" ; \
make ; make install ; cp /home/colin/git_home/axtls-code/_stage/libaxtls.a /home/colin/git_home/nattraversal-client/3rd-party/libcURL/unix/x86 ; \
expect -c "
   set timeout 1
   spawn scp /home/colin/git_home/axtls-code/_stage/libaxtls.a $Local_User@$Local_IP:$Dest
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   exit
"'

#=====comment nonblocking entry=====
docker exec $Container_ID sed -i 's:#define curlssl_connect_nonblocking Curl_axtls_connect_nonblocking://#define curlssl_connect_nonblocking Curl_axtls_connect_nonblocking:g' \
/home/colin/git_home/curl/lib/vtls/axtls.h

#==========

#=====build curl=====
docker exec -e Local_IP=$Local_IP -e Local_User=$Local_User -e Local_Passwd=$Local_Passwd -e Dest=$Dest $Container_ID bash -c 'cd /home/colin/git_home/curl ; \
git checkout curl-7_54_0 ; ./buildconf ; export CFLAGS="-fPIC" ; \
./configure --without-ssl --disable-ftp --disable-gopher --disable-file --disable-imap --disable-ldap --disable-ldaps \
--disable-pop3 --disable-proxy --disable-rtsp --disable-smtp --disable-telnet --disable-tftp --without-gnutls --disable-dict --with-axtls --disable-shared \
--disable-manual --without-zlib ; \
make ; cp /home/colin/git_home/curl/lib/.libs/libcurl.a /home/colin/git_home/nattraversal-client/3rd-party/libcURL/unix/x86 ; \
expect -c "
   set timeout 1
   spawn scp /home/colin/git_home/curl/lib/.libs/libcurl.a $Local_User@$Local_IP:$Dest
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   exit
"'

#=====edit makefile link from openssl to axtls=====
docker exec $Container_ID sed -i -e 's:\ \-lssl:\ \-laxtls:g' -e 's:\ \-lcrypto::g' -e 's:\ \-lz::g' -e 's:\ \-lidn::g' /home/colin/git_home/nattraversal-client/build/linux/Makefile 

docker exec $Container_ID sed -i -e 's:\ \-lssl:\ \-laxtls:g' -e 's:\ \-lcrypto::g' -e 's:\ \-lz::g' -e 's:\ \-lidn::g' /home/colin/git_home/nattraversal-client/Samples/linux/Makefile

#==========

#=====build target project=====
docker exec -e Local_IP=$Local_IP -e Local_User=$Local_User -e Local_Passwd=$Local_Passwd -e Dest=$Dest $Container_ID bash -c 'cd /home/colin/git_home/nattraversal-client/build/linux ; \
make ; cp /home/colin/git_home/nattraversal-client/build/linux/liborbwebM2M.a /home/colin/git_home/nattraversal-client/Samples/linux ; \
cd /home/colin/git_home/nattraversal-client/Samples/linux ; make ; \
expect -c "
   set timeout 1
   spawn scp /home/colin/git_home/nattraversal-client/Samples/linux/bin/sample $Local_User@$Local_IP:$Dest
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   exit
"'

#=====remove docker=====
docker stop $Container_ID

docker rm $Container_ID

#=====remove images=====
docker rmi $IMAGE_ID

docker rmi $ORI_ID


echo "Build Successful! Output path:$Dest"
