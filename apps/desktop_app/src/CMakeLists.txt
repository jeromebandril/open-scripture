# zlib
file(GLOB ZLIB_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib/*.c")
add_library(zlib_static STATIC ${ZLIB_SOURCES})
target_include_directories(zlib_static PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/zlib")

# bzip2
file(GLOB BZIP2_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/bzip2/*.c")
add_library(bzip2_static STATIC ${BZIP2_SOURCES})
target_include_directories(bzip2_static PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/bzip2")

target_link_libraries(native_sword_bridge PRIVATE zlib_static bzip2_static)

target_compile_options(native_sword_bridge PRIVATE
  /FI"${CMAKE_CURRENT_SOURCE_DIR}/libsword/include/msvc_compat.h"
)

target_compile_definitions(native_sword_bridge PRIVATE
  WIN32_LEAN_AND_MEAN
  NOMINMAX           # prevents min/max macro collisions with std::min/max
  _CRT_SECURE_NO_WARNINGS
  UNICODE
  _UNICODE
)