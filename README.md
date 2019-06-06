# Github Action for CMake

An action for building CMake projects.

## Usage

There are two ways of using this action, (1) to build the repository 
where the workflow is stored, or (2) to clone a CMake project into the 
workspace and build it.

### Example Workflow

To clone and build at the same time:

```hcl
workflow "compile a cmake project" {
  on = "push"
  resolves = "build"
}

action "build" {
  uses = "popperized/cmake@master"
  args = "install"
  env = {
    CMAKE_GIT_REPO = "https://github.com/bast/cmake-example",
    CMAKE_GIT_REF = "dev",
    CMAKE_INSTALL_DEPS_SCRIPT = "scripts/install_deps.sh",
    CMAKE_FLAGS = "-DCMAKE_INSTALL_PREFIX:PATH=/tmp/foo",
    CMAKE_BUILD_THREADS = "8"
  }
}
```

Or to run for an existing folder:

```hcl
workflow "compile a cmake project" {
  on = "push"
  resolves = "build"
}

action "build" {
  uses = "popperized/cmake@master"
  args = "install"
  env = {
    CMAKE_PROJECT_DIR = "./",
    CMAKE_FLAGS = "-DCMAKE_INSTALL_PREFIX:PATH=$GITHUB_WORKSPACE/install",
    CMAKE_CLEAN = 1
  }
}
```

### Environment

  * `CMAKE_GIT_REPO` **optional** a string containing a valid Git URL 
    of a repo. This repo is assumed to be a CMake project, which is 
    cloned into the workspace and built. Either this or 
    `CMAKE_PROJECT_DIR` is expected.

  * `CMAKE_GIT_REF` **optional** the Git REF intended to be checked 
    out. If not given, the default branch is checked out.

  * `CMAKE_PROJECT_DIR` **optional** the path to the folder in the 
    workspace containing the CMake project to build. Either this or 
    `CMAKE_GIT_REPO` is expected.

  * `CMAKE_INSTALL_DEPS_SCRIPT` **optional** The path to an executable 
    bash script that is invoked prior to running CMake which can be 
    used to install build dependencies (base image is Debian 10).

  * `CMAKE_FLAGS` **optional** a string containing flags that are 
    passed to the `cmake` command. Empty string by default.

  * `CMAKE_CLEAN` **optional** remove the `build/` folder prior 
    to executing `cmake`. By default (when this variable is not set), 
    the `build/` is left intact.

  * `CMAKE_BUILD_THREADS` **optional** number of threads used to build 
    the project; passed to `make` via the `-j` flag. By default this 
    is `grep processor /proc/cpuinfo | wc -l`.

# License

[MIT](LICENSE)
