#!/bin/bash
echo Build started on `date`
apt-get update -y
apt-get install -y software-properties-common
apt-add-repository "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.8 main"
#add-apt-repository ppa:george-edison55/cmake-3.x
add-apt-repository ppa:ubuntu-toolchain-r/test
#deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-3.8 main
#deb-src http://apt.llvm.org/trusty/ llvm-toolchain-trusty-3.8 main
#wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
apt-get update -y
apt-get install -y llvm-toolchain-3.6 clang-3.6  lldb-3.6 libc++-dev openjdk-7-jdk swig m4 libgmp-dev libboost-dev libgmp-dev libboost-thread-dev libcln-dev antlr3 libantlr3c-dev
#apt-get install -y clang-3.8-doc libclang-common-3.8-dev libclang-3.8-dev libclang1-3.8 libclang1-3.8-dbg libllvm-3.8-ocaml-dev libllvm3.8 libllvm3.8-dbg lldb-3.8 llvm-3.8 llvm-3.8-dev llvm-3.8-doc llvm-3.8-examples llvm-3.8-runtime clang-modernize-3.8 clang-format-3.8 python-clang-3.8 lldb-3.8-dev
#curl http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add
echo 'deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.8 main' >> /etc/apt/sources.list
apt-get update -y
#apt-get install -y clang-3.8 lldb-3.8
wget http://sourceforge.net/projects/cxxtest/files/cxxtest/4.3/cxxtest-4.3.tar.gz
tar -xzvf cxxtest-4.3.tar.gz
cp -vRT cxxtest-4.3 $HOME/cxxtest
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
export JAVA_CPPFLAGS=-I$JAVA_HOME/include
touch envdata
echo "getting paths of binaries" >> envdata
#which java >> envdata
#java -version >> envdata
#which javac >> envdata
echo "where is clang" >> envdata
which clang-3.6 >> envdata
#clang-3.8 --version >> envdata
which llvm-symbolizer >> envdata
echo "get system info" >> envdata
uname -a >> envdata
free -m >> envdata
ldd --version >> envdata
cat /proc/cpuinfo >> envdata
#git clone https://github.com/chadbrewbaker/CVC4.git
#pushd CVC4
./autogen.sh
#./configure --with-build=debug --enable-language-bindings=java,c --disable-proof
#make -n > recon1
./configure  --with-build=debug --enable-shared  --enable-language-bindings=java,c CXXTEST=$HOME/cxxtest --disable-proof 
#iCC=/usr/bin/clang-3.6 CXX=/usr/bin/clang++-3.6 LD=/usr/bin/clang-3.6
cat make > recon1
make -n > recon2
#CFLAGS="-fno-omit-frame-pointer  -g" \
#LDFLAGS=" " \
#CXXFLAGS="-fno-omit-frame-pointer -g" 
make -j3
popd
find ./CVC4 -name "*.jar" >> envdata
find ./CVC4 -name "*.class" >> envdata
find ./CVC4 -name "*.so" >> envdata
find ./CVC4 -name "*.dyld" >> envdata
apt-get install -y valgrind
touch CVC4.tar
cp ./CVC4/builds/x86_64-unknown-linux-gnu/debug-noproof/src/bindings/java/.libs/libcvc4jni.so ./
cp ./CVC4/builds/x86_64-unknown-linux-gnu/debug-noproof/src/bindings/java/classes/edu/nyu/acsys/CVC4/*.class ./
unzip ./CVC4/builds/x86_64-unknown-linux-gnu/debug-noproof/src/bindings/CVC4.jar
cp edu/nyu/acsys/CVC4/*.class ./
pwd >> envdata
ls >> envdata
javac Test.java 
echo "running code " >> envdata
java -Djava.library.path=./ Test >> envdata
java -Djava.library.path=./ Test >> envdata 2>&1
echo "done running code" >> envdata
#cat CVC4/recon1 >> envdata
#echo "second recon" >> envdata
#cat CVC4/recon2 >> envdata
valgrind --trace-children=yes --leak-check=full java  -Djava.library.path=./ Test >> envdata 2>&1
#valgrind --track-origins=yes java -Djava.library.path=./ -Djava.compiler=NONE Test >> envdata 2>&1
#tar -c CVC4 > CVC4.tar
