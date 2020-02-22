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
  apt-get update
  source $CMAKE_INSTALL_DEPS_SCRIPT
  apt-get clean -y
fi

BUILD_DIR="$CMAKE_PROJECT_DIR/build"

if [ "$CMAKE_CLEAN" == "true" ] || [ ! -d $BUILD_DIR ]; then
  rm -rf $BUILD_DIR
  git -C "$CMAKE_PROJECT_DIR" submodule update --init --recursive
fi

mkdir -p $BUILD_DIR

if [ -z "$(ls -A $BUILD_DIR)" ] || [ "$CMAKE_RECONFIGURE" == "true" ] ; then
  cmake $CMAKE_FLAGS -H. -B$BUILD_DIR
fi

if [ -z "$CMAKE_BUILD_THREADS" ] ; then
  CMAKE_BUILD_THREADS=`grep processor /proc/cpuinfo | wc -l`
fi

cmake --build $BUILD_DIR $@
