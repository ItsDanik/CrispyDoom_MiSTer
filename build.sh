#!/bin/sh
# Build Doom for the MiSTer in the toolchain container: static SDL2 with the
# hybrid core drivers first (once), then the game.
# usage: ./build.sh [mister|host] [Release|RelWithDebInfo|Debug]
#   mister  ARM binary for the MiSTer     -> build/mister/src/crispy-doom
#           (and crispy-heretic, -hexen, -strife, which crispy-doom starts
#           for those games)
#   host    same code for this PC, to run against hybrid/tools/fakecore
set -e
cd "$(dirname "$0")"
TARGET=${1:-mister}
TYPE=${2:-Release}
ROOT=$PWD
PREFIX=$ROOT/build/sdl/$TARGET/prefix

hybrid/docker.sh hybrid/sdl2/build.sh "$TARGET" build/sdl

CROSS=
if [ "$TARGET" = mister ]; then
    CROSS="-DCMAKE_TOOLCHAIN_FILE=$ROOT/hybrid/toolchain/mister.cmake -DCMAKE_FIND_ROOT_PATH=$PREFIX"
    # the compiler's runtime is linked in, the binary only needs the MiSTer's glibc
    CROSS="$CROSS -DCMAKE_EXE_LINKER_FLAGS='-no-pie -static-libstdc++ -static-libgcc'"
fi

# GAME: the game's own CMake options go on the first cmake line (the option
# that turns on its MiSTer code, bundled libraries instead of system ones)
hybrid/docker.sh sh -c "
  cmake -S crispydoom -B build/$TARGET -DCMAKE_BUILD_TYPE=$TYPE $CROSS \
    -DCMAKE_PREFIX_PATH=$PREFIX -DMISTER_HYBRID=ON \
    -DCMAKE_C_STANDARD_LIBRARIES='-lm -lpthread -ldl' &&
  cmake --build build/$TARGET --target crispy-doom crispy-heretic crispy-hexen crispy-strife -j\$(nproc)"
ls -la "build/$TARGET/src/crispy-doom" "build/$TARGET/src/crispy-heretic" \
    "build/$TARGET/src/crispy-hexen" "build/$TARGET/src/crispy-strife"

# The launch script's messages on the core's picture (hybrid/tools/mh_message.c)
if [ "$TARGET" = mister ]; then
    hybrid/docker.sh arm-linux-gnueabihf-gcc -O2 -static -Ihybrid/hps -o build/mister/mh_message \
        hybrid/tools/mh_message.c hybrid/hps/*.c -lpthread -lm
fi
