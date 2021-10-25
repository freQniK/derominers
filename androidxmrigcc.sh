#!/bin/bash


CCDIR="/data/data/com.termux/files/home/CC"
GITDIR="/data/data/com.termux/files/home/CC/git"

git_and_build_hwloc() {
        if [ ! -d "$GITDIR" ]; then
                mkdir "$GITDIR"
        fi

        cd "$GITDIR"
        git clone https://github.com/open-mpi/hwloc
        cd hwloc
        ./autogen.sh && ./configure &&  make

}

if [ ! -d "$CCDIR" ]; then
        mkdir "$CCDIR"
fi
echo "We need to change the termux repo. Select (grimler) for best results on main repo"
echo -ne "(Press enter to continue): "
read blah
sleep 1
termux-change-repo
apt-get -q -y install autoconf automake cmake git libtool 
git_and_build_hwloc

cd "$GITDIR" && git clone https://github.com/freQniK/xmrigCC
cd xmrigCC && mkdir build && cd build
cmake .. -DHWLOC_INCLUDE_DIR=$GITDIR/hwloc/include -DHWLOC_LIBRARY=$GITDIR/hwloc/hwloc/.libs/libhwloc.so
make
echo "Now run: ./derominers.sh"
echo "bye."



