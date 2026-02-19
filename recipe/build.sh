#! /bin/bash
# Prior to conda-forge, Copyright 2017-2019 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

set -ex

meson_config_args=(
        -D docs=false
        -D tests=false
)

if [[ $target_platform == osx* ]] ; then
    meson_config_args+=(
        -D x11=false
    )
else
    meson_config_args+=(
        -D egl=yes
        -D x11=true
    )
fi

meson setup builddir \
    "${meson_config_args[@]}" \
    --prefix=$PREFIX \
    --libdir=$PREFIX/lib  \
    --wrap-mode=nofallback
ninja -v -C builddir -j ${CPU_COUNT}
ninja -C builddir install -j ${CPU_COUNT}

cd $PREFIX
find . '(' -name '*.la' -o -name '*.a' ')' -delete
