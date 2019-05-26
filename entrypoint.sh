#!/bin/bash
set -ex

CMAKE_PROJECT_DIR="$PWD"

if [ -n "$CMAKE_GIT_REPO" ]; then
  CMAKE_PROJECT_DIR="$CMAKE_PROJECT_DIR/$(basename $CMAKE_GIT_REPO)"

  if [ ! -f "$CMAKE_PROJECT_DIR/.git" ]; then
    git clone --branch $CMAKE_GIT_REF --depth=1 "$CMAKE_GIT_REPO"
  fi
fi

if [ -n "$CMAKE_INSTALL_DEPS_SCRIPT" ]; then
  $CMAKE_INSTALL_DEPS_SCRIPT
fi

if [ "$CMAKE_CLEAN" == "true" ] || [ ! -d "$CMAKE_PROJECT_DIR/build"]; then
  rm -rf "$CMAKE_PROJECT_DIR/build"
  git -C "$CMAKE_PROJECT_DIR" submodule update --init --recursive
fi

mkdir -p "$CMAKE_PROJECT_DIR/build"

cd "$CMAKE_PROJECT_DIR/build"

if [ -z "$(ls -A ./)" ] || [ "$CMAKE_RECONFIGURE" == "true" ] ; then
  cmake $CMAKE_FLAGS ..
fi

if [ -z "$CMAKE_BUILD_THREADS" ] ; then
  CMAKE_BUILD_THREADS=`grep processor /proc/cpuinfo | wc -l`
fi

make -j$CMAKE_BUILD_THREADS $@
