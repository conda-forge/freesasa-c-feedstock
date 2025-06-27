#!/bin/bash

set -exo pipefail

export PKG_CONFIG_PATH="${CONDA_BUILD_SYSROOT}/usr/lib/pkgconfig:${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}"

cd "${SRC_DIR}"

autoreconf -fvi

if [[ "${target_platform}" == "win-"* ]]; then
    # Use `-disable-json` due to no m2-json-c package
    ./configure --prefix="${PREFIX}" \
        --disable-json \
        --disable-xml \
        --enable-shared \
        --disable-static \
        --disable-debug \
        --disable-dependency-tracking \
        --enable-silent-rules \
        --disable-option-checking
else
    ./configure --prefix="${PREFIX}" \
        --enable-shared \
        --disable-static \
        --disable-debug \
        --disable-dependency-tracking \
        --enable-silent-rules \
        --disable-option-checking
fi

if [[ "${target_platform}" == "linux-"* || "${target_platform}" == "win-"* ]]; then
    sed -i.bak 's|-lc++|-lstdc++|' src/Makefile
fi

make -j"${CPU_COUNT}"
make install
