#pragma once
#ifdef _WIN32
#include <io.h>
#include <process.h>
#define R_OK 4
#define W_OK 2
#define F_OK 0
#define access _access
#define getpid _getpid
#endif