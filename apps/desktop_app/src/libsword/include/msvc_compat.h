#pragma once

#ifndef _BZIP2_
#define _BZIP2_
#endif

#ifndef _ZLIB_
#define _ZLIB_
#endif

#ifdef _MSC_VER
#include <string.h>
#define strcasecmp  _stricmp
#define strncasecmp _strnicmp
#endif

#ifdef _MSC_VER
#ifndef __attribute__
#define __attribute__(x)
#endif
#endif