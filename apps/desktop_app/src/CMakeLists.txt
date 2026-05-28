cmake_minimum_required(VERSION 3.14)
project(native_sword_bridge CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# zlib

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
)
add_library(zlib_static STATIC ${ZLIB_SOURCES})
target_include_directories(zlib_static PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib")
set_target_properties(zlib_static PROPERTIES POSITION_INDEPENDENT_CODE ON)

# bzip2
file(GLOB BZIP2_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/bzip2/*.c")
add_library(bzip2_static STATIC ${BZIP2_SOURCES})
target_include_directories(bzip2_static PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/bzip2")
set_target_properties(bzip2_static PROPERTIES POSITION_INDEPENDENT_CODE ON)

# libsword core
file(GLOB_RECURSE SWORD_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/keys/*.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/mgr/*.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/modules/*.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/utilfuns/*.cpp"
)
list(REMOVE_ITEM SWORD_SOURCES
  # cURL network transports (downloading handled in Dart)
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/mgr/curlftpt.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/mgr/curlhttpt.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/mgr/ftplibftpt.cpp"
  # LZMA compression (deferred, very rare modules use this)
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/modules/common/xzcomprs.cpp"
  # SWORD's own Win32 dirent (conflicts with the tronkko header shim)
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/utilfuns/win32/dirent.cpp"
)
# Add MSVC regex shim implementation
list(APPEND SWORD_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/src/utilfuns/regex_msvc.cpp"
)
add_library(sword_core STATIC ${SWORD_SOURCES})

target_include_directories(sword_core PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/include")
target_link_libraries(sword_core PUBLIC zlib_static bzip2_static)
set_target_properties(sword_core PROPERTIES POSITION_INDEPENDENT_CODE ON)

target_compile_definitions(sword_core PRIVATE
  WIN32_LEAN_AND_MEAN
  NOMINMAX
  _CRT_SECURE_NO_WARNINGS
  UNICODE
  _UNICODE
)
target_compile_options(sword_core PRIVATE
  /EHsc
  /wd4267
  /wd4244
  /wd4996
  /FI"${CMAKE_CURRENT_SOURCE_DIR}/libsword/include/msvc_compat.h"
)

# bridge DDL
add_library(native_sword_bridge SHARED
  "${CMAKE_CURRENT_SOURCE_DIR}/native_bridge.cpp"
)
target_include_directories(native_sword_bridge PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/libsword/include"
)
target_link_libraries(native_sword_bridge PRIVATE sword_core)

target_compile_definitions(native_sword_bridge PRIVATE
  WIN32_LEAN_AND_MEAN
  NOMINMAX
  _CRT_SECURE_NO_WARNINGS
)
target_compile_options(native_sword_bridge PRIVATE
  /EHsc
  /FI"${CMAKE_CURRENT_SOURCE_DIR}/libsword/include/msvc_compat.h"
)

# output the DLL next to the Flutter executable
set_target_properties(native_sword_bridge PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/runner/Release"
)