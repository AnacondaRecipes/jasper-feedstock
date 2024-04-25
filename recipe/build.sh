#!/bin/bash

set -eo pipefail

declare -a CMAKE_PLATFORM_FLAGS

mkdir build_shared && cd $_
cmake -G "Ninja" \
    ${CMAKE_ARGS} \
    -DALLOW_IN_SOURCE_BUILD=ON \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=ON \
    -DJAS_ENABLE_LIBHEIF=OFF \
    -DJAS_ENABLE_DOC=OFF \
    "${CMAKE_PLATFORM_FLAGS[@]}" ..

cmake --build . --config Release --target=install --parallel ${CPU_COUNT}
ctest --output-on-failure || true
cd ..

if [[ $(uname) == Darwin ]]; then
    mkdir build_static && cd $_
    cmake -G "Ninja" \
        ${CMAKE_ARGS} \
        -DALLOW_IN_SOURCE_BUILD=ON \
        -DCMAKE_PREFIX_PATH=$PREFIX \
        -DCMAKE_INSTALL_PREFIX=$PREFIX \
        -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=ON \
        -DJAS_ENABLE_LIBHEIF=OFF \
        -DJAS_ENABLE_DOC=OFF \
        "${CMAKE_PLATFORM_FLAGS[@]}" ..

    cmake --build . --config Release --target=install --parallel ${CPU_COUNT}
    ctest --output-on-failure || true
    cd ..
fi