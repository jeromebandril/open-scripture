#pragma once
#ifdef _MSC_VER
#include <string.h>
#define strcasecmp  _stricmp
#define strncasecmp _strnicmp
#define snprintf    _snprintf   // only needed on very old MSVC
#endif

#ifdef _MSC_VER
#ifndef __attribute__
#define __attribute__(x)
#endif
#endif