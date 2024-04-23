#!/bin/bash

set -eo pipefail

declare -a CMAKE_PLATFORM_FLAGS

mkdir build_shared && cd $_
cmake ${CMAKE_ARGS} \
    -DALLOW_IN_SOURCE_BUILD=ON \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=ON \
    -DJAS_ENABLE_LIBHEIF=OFF \
    -JAS_ENABLE_DOC=OFF \
    "${CMAKE_PLATFORM_FLAGS[@]}" ..
make -j${CPU_COUNT}
make install
cd ..
