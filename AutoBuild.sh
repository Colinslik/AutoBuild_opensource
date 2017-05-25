#!/bin/bash

#=====Argument setup=====

if [ -z "$1" ]; then
  Dest="$(pwd)/lib"
else
  Dest="$1/lib"
fi

Container_ID=ubuntu64

Git_ID=<Git_ID>

Git_Passwd=<Git_passwd>

Local_IP=<Local_IP>

Local_User=root

Local_Passwd=orbwebroot

#=======================

mkdir -p $Dest

echo "Output Path:$Dest"

#=====get Base image ID=====
IMAGE_ID=$(docker build -t orbweb/ubuntu64:v1 /home/colin/dockerfiles/Ubuntu_64bit/ 2>/dev/null | awk '/Successfully built/{print $NF}')

echo $IMAGE_ID

#=====get Current image ID=====
ORI_ID=$(docker images -q ubuntu)

echo $ORI_ID

#=====create docker in background=====
docker run -id --name $Container_ID orbweb/ubuntu64:v1 /bin/bash

#docker start $Container_ID


#=====clone all necessary parts=====
docker exec -e Git_ID=$Git_ID -e Git_Passwd=$Git_Passwd $Container_ID bash -c 'cd /home/colin/git_home ; \
git clone http://$Git_ID:$Git_Passwd@git.kloudian.com/gitadmin/nattraversal-client.git ; \
git clone http://$Git_ID:$Git_Passwd@git.kloudian.com/harold.chen/libuv.git ; \
git clone https://github.com/open-source-parsers/jsoncpp.git ; \
git clone https://github.com/madler/zlib.git ; \
git clone https://github.com/openssl/openssl.git ; \
git clone https://github.com/curl/curl.git
'

#=====build open UV=====
docker exec -e Local_IP=$Local_IP -e Local_User=$Local_User -e Local_Passwd=$Local_Passwd -e Dest=$Dest $Container_ID bash -c 'cd /home/colin/git_home/libuv ; \
sh autogen.sh ; ./configure ; make ; cp /home/colin/git_home/libuv/.libs/libuv.a /home/colin/git_home/nattraversal-client/3rd-party/libuv/lib/unix/x64 ; \
expect -c "  
   set timeout 1
   spawn scp /home/colin/git_home/libuv/.libs/libuv.a $Local_User@$Local_IP:$Dest
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   exit
"'

#=====build jsonCpp=====
docker exec -e Local_IP=$Local_IP -e Local_User=$Local_User -e Local_Passwd=$Local_Passwd -e Dest=$Dest $Container_ID bash -c 'cd /home/colin/git_home/jsoncpp ; \
git checkout 0.7.1 ; mkdir -p /home/colin/git_home/jsoncpp/output ; cd /home/colin/git_home/jsoncpp/output ; cmake ../ ; make ; \
cp /home/colin/git_home/jsoncpp/output/lib/libjsoncpp.a /home/colin/git_home/nattraversal-client/3rd-party/jsoncpp/lib/linux/x64 ; \
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
./configure ; make ; make install ; cp /home/colin/git_home/zlib/libz.a /home/colin/git_home/nattraversal-client/3rd-party/libcURL/unix/x64 ; \
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
cp /home/colin/git_home/openssl/libssl.a /home/colin/git_home/nattraversal-client/3rd-party/libcURL/unix/x64 ; \
cp /home/colin/git_home/openssl/libcrypto.a /home/colin/git_home/nattraversal-client/3rd-party/libcURL/unix/x64 ; \
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

#=====build curl=====
docker exec -e Local_IP=$Local_IP -e Local_User=$Local_User -e Local_Passwd=$Local_Passwd -e Dest=$Dest $Container_ID bash -c 'cd /home/colin/git_home/curl ; \
./buildconf ; ./configure ; make ; cp /home/colin/git_home/curl/lib/.libs/libcurl.a /home/colin/git_home/nattraversal-client/3rd-party/libcURL/unix/x64 ; \
expect -c "
   set timeout 1
   spawn scp /home/colin/git_home/curl/lib/.libs/libcurl.a $Local_User@$Local_IP:$Dest
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $Local_Passwd\r }
   expect 100%
   sleep 1
   exit
"'

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

docker rm ubuntu64

#=====remove images=====
docker rmi $IMAGE_ID

docker rmi $ORI_ID


echo "Build Successful! Output path:$Dest"
