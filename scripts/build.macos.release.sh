#!/bin/bash
set -xe

brew reinstall rapidjson libevent zlib pcre2 pkgconfig

#git clone https://github.com/curl/curl --depth=1 --branch curl-7_88_1
#cd curl
#./buildconf > /dev/null
#./configure --with-ssl=/usr/local/opt/openssl@1.1 --without-mbedtls --disable-ldap --disable-ldaps --disable-rtsp --without-libidn2 > /dev/null
#cmake -DCMAKE_USE_SECTRANSP=ON -DHTTP_ONLY=ON -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_USE_LIBSSH2=OFF . > /dev/null
#make -j8 > /dev/null
#cd ..

git clone https://github.com/jbeder/yaml-cpp --depth=1
cd yaml-cpp
cmake -DCMAKE_BUILD_TYPE=Release -DYAML_CPP_BUILD_TESTS=OFF -DYAML_CPP_BUILD_TOOLS=OFF . > /dev/null
sudo make install -j8 > /dev/null
cd ..

git clone https://github.com/ftk/quickjspp --depth=1
cd quickjspp
cmake -DCMAKE_BUILD_TYPE=Release .
sudo make quickjs -j8
sudo install -d /usr/local/lib/quickjs/
sudo install -m644 quickjs/libquickjs.a /usr/local/lib/quickjs/
sudo install -d /usr/local/include/quickjs/
sudo install -m644 quickjs/quickjs.h quickjs/quickjs-libc.h /usr/local/include/quickjs/
sudo install -m644 quickjspp.hpp /usr/local/include/
cd ..

git clone https://github.com/PerMalmberg/libcron --depth=1
cd libcron
git submodule update --init
cmake -DCMAKE_BUILD_TYPE=Release .
sudo make libcron install -j8
sudo install -m644 libcron/out/Release/liblibcron.a /usr/local/lib/
sudo install -d /usr/local/include/libcron/
sudo install -m644 libcron/include/libcron/* /usr/local/include/libcron/
sudo install -d /usr/local/include/date/
sudo install -m644 libcron/externals/date/include/date/* /usr/local/include/date/
cd ..

git clone https://github.com/ToruNiina/toml11 --depth=1
cd toml11
cmake -DCMAKE_CXX_STANDARD=11 .
sudo make install -j4
cd ..

cp /opt/homebrew/lib/libevent.a .
cp /opt/homebrew/opt/zlib/lib/libz.a .
cp /opt/homebrew/lib/libpcre2-8.a .

cmake -DCMAKE_BUILD_TYPE=Release .
make -j8
rm subconverter
c++ -Xlinker -unexported_symbol -Xlinker "*" -o base/subconverter -framework CoreFoundation -framework Security $(find CMakeFiles/subconverter.dir/src/ -name "*.o") $(find . -name "*.a") -lcurl -O3

cd base
chmod +rx subconverter
chmod +r ./*
cd ..
mv base subconverter

set +xe
