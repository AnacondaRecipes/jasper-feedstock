#!/bin/bash

set -eo pipefail

export PKG_CONFIG_PATH="${BUILD_PREFIX}/bin/pkg-config:${BUILD_PREFIX}/lib/pkgconfig:${PREFIX}/bin/pkg-config:${PREFIX}/lib/pkg-config"
export PKG_CONFIG_EXECUTABLE=${PREFIX}/bin/pkg-config

declare -a CMAKE_PLATFORM_FLAGS

mkdir build_shared && cd $_
cmake -G "Ninja" \
    ${CMAKE_ARGS} \
    -DALLOW_IN_SOURCE_BUILD=ON \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DJAS_ENABLE_LIBHEIF=OFF \
    -DJAS_ENABLE_DOC=OFF \
    -DJAS_PACKAGING=ON \
    "${CMAKE_PLATFORM_FLAGS[@]}" ..

cmake --build . --config Release --target=install --parallel ${CPU_COUNT}
ctest --output-on-failure
cd ..
