[![C/C++ CI](https://github.com/godotengine/godot-git-plugin/actions/workflows/build.yml/badge.svg)](https://github.com/godotengine/godot-git-plugin/actions/workflows/build.yml)

# GDNative Based Git Plugin for Godot Version Control Editor Plugin

Git implementation of the Godot Engine VCS interface in Godot. We use [libgit2](https://libgit2.org) as our backend to simulate Git in code.

**Works only for the Godot 3.2.x-3.4.x releases**

## Installation Instructions

 1. Grab the platform binaries here: <https://github.com/godotengine/godot-git-plugin/releases>
 2. Then read the installation instructions: https://github.com/godotengine/godot-git-plugin/wiki

## Build Instructions

### Pre-requisites

Required build tools:

* [CMake](https://cmake.org/download/) (v3.5.1+)
* [SCons](https://scons.org/pages/download.html) (v3.0.1+)

### Windows

> MSVC is our recommended compiler for Windows

1. Load the x64 command prompt: `x64 Native Tools Command Prompt for VS 20XX`.
2. Run ```build_libs.bat Release```.
3. Run ```scons platform=windows target=release```

### Linux

> G++ is our recommended compiler for Linux

1. Prepare script for execution: ```chmod 755 build_libs.sh```
2. Run ```. ./build_libs.sh Release```.
3. Run ```scons platform=x11 target=release```.

### MacOS

> G++ and Clang++ are our recommended compilers for MacOS

1. Prepare script for execution: ```chmod 755 build_libs_mac.sh```
2. Run ```. ./build_libs_mac.sh Release```.
3. Run ```scons platform=osx target=release```.

### Debug build

Replace `Release` with `Debug` and `release` with `debug` in the above instructions for a debug build. You will also have to do the same in the paths mentioned in `demo/git_api.gdnlib` before opening the demo project in Godot.

### Bleeding Edge Builds

> This section onwards is only meant to be used by developers.

Most of the times when new features are being worked on for the Godot VCS Integration, this requires us to make changes in Godot along with this plugin. Thus, this means we need to manually generate the GDNative API from these newer Godot builds and then use them with godot-cpp.

1. Generate `api.json` from Godot executable: `godot --gdnative-generate-json-api api.json`
2. Change directory to `godot-cpp`: `cd godot-cpp`
3. Build the C++ bindings: `scons platform=<platform> target=<target> generate_bindings=yes bits=64 use_custom_api_file=yes custom_api_file=<path/to/api.json> -j <number of CPUs>`
4. Change directory up one level: `cd ..`
5. Build the plugin as usual: `scons platform=<windows> target=<target>`
