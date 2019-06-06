#!/bin/bash
set -ex

if [ -z "$CMAKE_PROJECT_DIR" ] && [ -z "$CMAKE_GIT_REPO" ]; then
  echo "Expecting one of CMAKE_PROJECT_DIR or CMAKE_GIT_REPO"
  exit 1
fi
if [ -n "$CMAKE_PROJECT_DIR" ] && [ -n "$CMAKE_GIT_REPO" ]; then
  echo "Expecting only one of CMAKE_PROJECT_DIR or CMAKE_GIT_REPO"
  exit 1
fi

if [ -n "$CMAKE_GIT_REPO" ]; then
  CMAKE_PROJECT_DIR="$PWD/$(basename $CMAKE_GIT_REPO)"

  if [ ! -f "$CMAKE_PROJECT_DIR/.git" ]; then
    if [ -n "$CMAKE_GIT_REF" ]; then
      git clone --branch "$CMAKE_GIT_REF" --depth=1 "$CMAKE_GIT_REPO"
    else
      git clone --depth=1 "$CMAKE_GIT_REPO"
    fi
  fi
fi

if [ -n "$CMAKE_INSTALL_DEPS_SCRIPT" ]; then
  $CMAKE_INSTALL_DEPS_SCRIPT
fi

if [ "$CMAKE_CLEAN" == "true" ] || [ ! -d "$CMAKE_PROJECT_DIR/build" ]; then
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
