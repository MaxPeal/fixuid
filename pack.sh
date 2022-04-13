#!/bin/sh -e
cd "$(dirname "$0")"

display_usage() {
    echo "Usage:\n$0 [version]"
}

# check whether user had supplied -h or --help . If yes display usage
if [ $# = "--help" ] || [ $# = "-h" ]
then
    display_usage
    exit 0
fi

# check number of arguments
if [ $# -ne 1 ]
then
    display_usage
    exit 1
fi

build_go() {
        echo "packing $GOOS/$GOARCH" >&2
        export GOOS="$GOOS"
        export GOARCH="$GOARCH"
        ./build.sh
        rm -f fixuid-*"-$GOOS-$GOARCH.tar.gz"
        perm="$(id -u):$(id -g)"
        sudo chown root:root fixuid
        sudo chmod u+s fixuid
        tar -cvzf "fixuid-$1-$GOOS-$GOARCH.tar.gz" fixuid
        sudo chmod u-s fixuid
        sudo chown "$perm" fixuid
}


for GOOS in linux; do
    for GOARCH in amd64 386 arm64 arm mips64 mips mips64le mipsle ppc64 ppc64le riscv64 s390x; do
        build_go
    done
done
for GOOS in darwin; do
    for GOARCH in amd64 arm64 arm; do
        build_go
    done
done
