cmake_minimum_required(VERSION 3.14)
project(native_sword_bridge CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ==============================================================================
# 1. zlib Static Library Target
# ==============================================================================
set(ZLIB_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/adler32.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/compress.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/crc32.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/deflate.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/infback.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/inffast.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/inflate.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/inftrees.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/trees.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/uncompr.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/zutil.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/gzlib.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/gzread.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/gzclose.c"
)
add_library(zlib_static STATIC ${ZLIB_SOURCES})
target_include_directories(zlib_static PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib")
target_compile_definitions(zlib_static PRIVATE _CRT_SECURE_NO_WARNINGS)
set_target_properties(zlib_static PROPERTIES POSITION_INDEPENDENT_CODE ON)

# ==============================================================================
# 2. bzip2 Static Library Target
# ==============================================================================
file(GLOB BZIP2_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/bzip2/*.c")
add_library(bzip2_static STATIC ${BZIP2_SOURCES})
target_include_directories(bzip2_static PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/bzip2")
set_target_properties(bzip2_static PROPERTIES POSITION_INDEPENDENT_CODE ON)

# Force BZIP2 to skip standard Win32 DLL/stdcall conversions and compile as standard C
target_compile_definitions(bzip2_static PRIVATE 
  _CRT_SECURE_NO_WARNINGS
  _LIB
)
# ==============================================================================
# 3. libsword Core Target (Static)
# ==============================================================================
file(GLOB_RECURSE SWORD_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/keys/*.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/mgr/*.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/modules/*.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/utilfuns/*.cpp"
)

# Exclude unneeded assets & platform-conflicting files
list(REMOVE_ITEM SWORD_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/mgr/curlftpt.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/mgr/curlhttpt.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/mgr/ftplibftpt.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/utilfuns/win32/dirent.cpp"
)

# Append custom MSVC regex AND SWORD's internal minizip implementations
list(APPEND SWORD_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/utilfuns/regex_msvc.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/modules/common/ioapi.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/modules/common/unzip.c"
)

add_library(sword_core STATIC ${SWORD_SOURCES})

# PUBLIC allows downstream targets linking to sword_core to inherit these include directories
target_include_directories(sword_core PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/include"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/include/internal/unzip"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/lzma/include"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib"
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/bzip2"
)

# PUBLIC cascades these structural static libraries down to the bridge layer automatically
target_link_libraries(sword_core PUBLIC
  zlib_static
  bzip2_static
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/lzma/bin/liblzma.lib"
)
set_target_properties(sword_core PROPERTIES POSITION_INDEPENDENT_CODE ON)

# PUBLIC guarantees that _ZLIB_ and _BZIP2_ cross the boundaries into native_bridge.cpp!
target_compile_definitions(sword_core PUBLIC
  WIN32
  _LIB
  UNICODE
  _UNICODE
  _ZLIB_                   # Tells SWORD zlib engine is linked
  _BZIP2_                  # Tells SWORD bzip2 engine is linked
  _XZ_                     # Tells SWORD LZMA/XZ engine is linked
)

# Internal build rules can remain private to sword_core
target_compile_definitions(sword_core PRIVATE
  WIN32_LEAN_AND_MEAN
  NOMINMAX
  _CRT_SECURE_NO_WARNINGS
  _ITERATOR_DEBUG_LEVEL=0  # Prevents cross-boundary STL validation faults
)

target_compile_options(sword_core PRIVATE
  /EHsc /wd4267 /wd4244 /wd4996
  /FI"${CMAKE_CURRENT_SOURCE_DIR}/libsword/include/msvc_compat.h"
)

# ==============================================================================
# 4. Bridge Shared Library Wrapper (DLL)
# ==============================================================================
add_library(native_sword_bridge SHARED
  "${CMAKE_CURRENT_SOURCE_DIR}/native_bridge.cpp"
)

# Cleaned up: Paths and configs now inherit dynamically from sword_core
target_include_directories(native_sword_bridge PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/include"
)

target_link_libraries(native_sword_bridge PRIVATE 
  sword_core
)

target_compile_definitions(native_sword_bridge PRIVATE
  WIN32_LEAN_AND_MEAN
  NOMINMAX
  _CRT_SECURE_NO_WARNINGS
  _ITERATOR_DEBUG_LEVEL=0
)

target_compile_options(native_sword_bridge PRIVATE 
  /EHsc
  /FI"${CMAKE_CURRENT_SOURCE_DIR}/libsword/include/msvc_compat.h"
)

# Place the compiled DLL next to Flutter runtime executable
set_target_properties(native_sword_bridge PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/runner/$<CONFIG>"
)

# Post-build asset deployment for LZMA dependency
add_custom_command(TARGET native_sword_bridge POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/lzma/bin/liblzma.dll"
    "${CMAKE_BINARY_DIR}/runner/$<CONFIG>/liblzma.dll"
)