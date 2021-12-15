#!/bin/bash

UPDATE=0
UPDATEALL=0
GITDIR="/data/data/com.termux/files/home/git"
HWLOCDIR="$GITDIR/hwloc"
XMRIGDIR="$GITDIR/xmrig"



help_screen() { 
        echo " "
        echo "AndroidXmrig For DERO v0.1.0  (Fats Waller)"
        echo " "
        echo "Usage:"
        echo "      ./androidxmrig.sh [options]"
        echo " "
        echo "Options: "
        echo "          --update-all, Update all dependencies and latest xmrig version."
        echo "          -h|--help,    This help screen."
        echo " "
        exit                

}

git_and_build_hwloc() {
        if [ ! -d "$GITDIR" ]; then
                mkdir "$GITDIR"
        fi
        
        if [[ -d "$HWLOCDIR" ]]; then
                rm -rf "$HWLOCDIR"
        fi
        
        cd "$GITDIR"
        git clone https://github.com/open-mpi/hwloc
        cd hwloc
        ./autogen.sh && ./configure &&  make

}

compile_xmrig() {
        if [ -f "xmrig" ]; then
                echo -ne "Removing old soft-link..."
                rm xmrig
                sleep 1
                echo "Done."
        fi

        echo "Upgrading system dependencies... (You will need to respond to the prompts)"
        termux-change-repo
        apt-get -q -y install autoconf automake cmake git libtool bintuils
        apt-get full-upgrade -y
        
        if [ ! -d "$GITDIR" ]; then
                mkdir "$GITDIR"
        fi
        
        cd "$GITDIR"
        
        if [ -d "$XMRIGDIR" ]; then
                rm -rf xmrig
        fi
        
        if [ ! -d "$HWLOCDIR" ] || [ $UPDATEALL -eq 1 ]; then
                git_and_build_hwloc
        fi
        
        cd "$GITDIR"
      
        git clone https://github.com/freQniK/xmrig
        
        cd "$XMRIGDIR" && mkdir build && cd build
        cmake .. -DHWLOC_INCLUDE_DIR=/data/data/com.termux/files/home/git/hwloc/include -DHWLOC_LIBRARY=/data/data/com.termux/files/home/git/hwloc/hwloc/.libs/libhwloc.so
        make
        echo "Done."
        
        cd /data/data/com.termux/files/home
        ln -s /data/data/com.termux/files/home/git/xmrig/build/xmrig xmrig
        echo "Run: ./derominers.sh OR ./herominers.sh"
        
}




while [ "$#" -gt 0 ]; do
        key=${1}

        case ${key} in
                --update)
                        UPDATE=1
                        shift
                        ;;
                --update-all)
                        UPDATEALL=1
                        shift
                        ;;
                -h|--help)
                        help_screen
                        shift
                        ;;

                *)
                        shift
                        ;;
        esac
done


compile_xmrig


