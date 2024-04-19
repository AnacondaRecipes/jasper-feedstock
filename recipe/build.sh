#!/bin/bash

set -eo pipefail

declare -a CMAKE_PLATFORM_FLAGS
if [[ ${HOST} =~ .*linux.* ]]; then
    CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
fi

mkdir build_shared && cd $_
cmake ${CMAKE_ARGS} \
    -DALLOW_IN_SOURCE_BUILD=ON \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DJAS_STDC_VERSION="201112L" \
    -DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=False \
    "${CMAKE_PLATFORM_FLAGS[@]}" ..
make -j${CPU_COUNT}
make install
cd ..

mkdir build_static && cd $_
cmake ${CMAKE_ARGS} \
    -DALLOW_IN_SOURCE_BUILD=ON \
    -DJAS_ENABLE_SHARED=OFF \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DJAS_STDC_VERSION="201112L" \
    -DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=False \
    "${CMAKE_PLATFORM_FLAGS[@]}" ..
make -j${CPU_COUNT}
make install
cd ..
