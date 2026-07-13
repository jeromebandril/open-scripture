#pragma once
#ifdef _MSC_VER
// SWORD uses POSIX regex.h  
// redirect to C++11 <regex> equivalents via a minimal 
// POSIX-compatible shim for the subset SWORD actually uses
#include <string.h>

typedef struct {
    int re_nsub;
    void* internal;
} regex_t;

typedef struct {
    const char* rm_so_ptr;
    size_t rm_so;
    size_t rm_eo;
} regmatch_t;

#define REG_EXTENDED  1
#define REG_ICASE     2
#define REG_NOSUB     4
#define REG_NEWLINE   8
#define REG_NOTBOL   16
#define REG_NOTEOL   32

#define REG_NOERROR   0
#define REG_NOMATCH   1
#define REG_BADPAT    2
#define REG_ESPACE   12

#ifdef __cplusplus
extern "C" {
#endif
int  regcomp(regex_t* preg, const char* pattern, int cflags);
int  regexec(const regex_t* preg, const char* string, size_t nmatch,
             regmatch_t pmatch[], int eflags);
void regfree(regex_t* preg);
#ifdef __cplusplus
}
#endif

#endif // _MSC_VER