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