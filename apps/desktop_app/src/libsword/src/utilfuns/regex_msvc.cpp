#ifdef _MSC_VER
#include "regex.h"
#include <regex>
#include <string>
#include <cstring>
#include <cstdlib>

struct RegexInternal {
    std::regex re;
    int flags;
};

int regcomp(regex_t* preg, const char* pattern, int cflags) {
    try {
        auto flags = std::regex::ECMAScript;
        if (cflags & REG_ICASE)   flags |= std::regex::icase;
        if (cflags & REG_EXTENDED) flags |= std::regex::extended;
        auto* internal = new RegexInternal();
        internal->re = std::regex(pattern, flags);
        internal->flags = cflags;
        preg->internal = internal;
        preg->re_nsub = 0;
        return REG_NOERROR;
    } catch (...) {
        return REG_BADPAT;
    }
}

int regexec(const regex_t* preg, const char* str, size_t nmatch,
            regmatch_t pmatch[], int eflags) {
    if (!preg->internal) return REG_NOMATCH;
    auto* internal = static_cast<RegexInternal*>(preg->internal);
    try {
        std::string s(str);
        std::smatch m;
        if (!std::regex_search(s, m, internal->re)) return REG_NOMATCH;
        if (nmatch > 0 && pmatch) {
            pmatch[0].rm_so = (size_t)m.position(0);
            pmatch[0].rm_eo = (size_t)(m.position(0) + m.length(0));
        }
        return REG_NOERROR;
    } catch (...) {
        return REG_NOMATCH;
    }
}

void regfree(regex_t* preg) {
    delete static_cast<RegexInternal*>(preg->internal);
    preg->internal = nullptr;
}
#endif