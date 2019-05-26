# Github Action for CMake

An action for compiling CMake projects.

## Usage

There are two ways of using this action, (1) to build the repository 
where the workflow is stored, or (2) to clone a CMake project into the 
workspace and build it.

### Example Workflow

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
    CMAKE_INSTALL_DEPS_SCRIPT = "scripts/install_deps.sh",
    CMAKE_FLAGS = "-DCMAKE_INSTALL_PREFIX:PATH=/tmp/foo",
    CMAKE_BUILD_THREADS = "8"
  }
}
```

### Environment

  * `CMAKE_GIT_REPO` **optional** a string containing a valid Git URL 
    of a repo. This repo is assumed to be a CMake project, which is 
    cloned into the workspace and built.

  * `CMAKE_INSTALL_DEPS_SCRIPT` **optional** The path to an executable 
    bash script that is invoked prior to running CMake which can be 
    used to install build dependencies. We maintain multiple branches 
    for this action, corresponding to multiple base OSs (`ubuntu` and 
    `centos`).

  * `CMAKE_FLAGS`

  * `CMAKE_CMAKE_CLEAN`

  * `CMAKE_RECREATE_BUILD`

# License

[MIT](LICENSE)
