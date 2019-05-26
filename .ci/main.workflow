workflow "build a cmake project" {
  resolves = "build"
  on = "push"
}

action "build" {
  uses = "./"
  args = "install"
  env = {
    CMAKE_GIT_REPO = "https://github.com/bast/cmake-example",
    CMAKE_INSTALL_DEPS_SCRIPT = ".ci/install-deps.sh",
    CMAKE_FLAGS = "-DCMAKE_INSTALL_PREFIX:PATH=/tmp/foo",
    CMAKE_BUILD_THREADS = "2"
  }
}
