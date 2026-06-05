#include <windows.h>
#include <swmgr.h>
#include <swmodule.h>
#include <swtext.h>
#include <versekey.h>
#include <markupfiltmgr.h>
#include <cstring>
#include <cstdlib>
#include <string>
#include <sstream>
#include <iostream>


// Temporary XzCompress stub — prevents linker error when liblzma
// constructor is not resolved from sword_core
namespace sword {
    class SWCompress {};
    class XzCompress : public SWCompress {
    public:
        XzCompress() {}
        virtual ~XzCompress() {}
    };
}

// Engine state
// One global SWMgr instance. Dart calls sword_init() once at startup.
// All subsequent calls reuse this instance. Never exposed outside this file.

static sword::SWMgr* g_mgr = nullptr;

// Internal helpers 

// Allocates a C string copy on the heap. Dart MUST call sword_free_string()
// on every pointer returned by this bridge — no exceptions.
static char* alloc_string(const std::string& s) {
    char* buf = static_cast<char*>(malloc(s.size() + 1));
    if (!buf) return nullptr;
    memcpy(buf, s.c_str(), s.size() + 1);
    return buf;
}

// Helper to safely allocate a string that Flutter can grab without memory leaks
char* alloc_string(const char* str) {
    if (!str) return nullptr;
    size_t len = strlen(str) + 1;
    char* out = (char*)malloc(len);
    if (out) {
        strcpy_s(out, len, str); // Secure string copy on Windows
    }
    return out;
}


// Public C API 

extern "C" {

// Must be called once before any other function.
// module_path: absolute path to the directory containing your mods.d/ folder.
// Returns 1 on success, 0 on failure.
__declspec(dllexport)
int sword_init(const char* module_path) {
    if (g_mgr) {
        delete g_mgr;
        g_mgr = nullptr;
    }
    try {
        // PlainFilterMgr renders text as plain UTF-8 — no HTML markup.
        // Swap for MarkupFilterMgr(FMT_OSIS) later when you want rich text.
        g_mgr = new sword::SWMgr(
            module_path,
            true,
            new sword::MarkupFilterMgr(sword::FMT_PLAIN)
        );
        return g_mgr != nullptr ? 1 : 0;
    } catch (...) {
        return 0;
    }
}

// Returns a JSON array string of module names and descriptions.
// Format: [{"name":"KJV","description":"King James Version","type":"Biblical Texts"},...]
// Caller must free with sword_free_string().
__declspec(dllexport)
char* sword_list_modules() {
    if (!g_mgr) return alloc_string("[]");
    std::ostringstream json;
    json << "[";
    bool first = true;
    for (auto& [key, mod] : g_mgr->getModules()) {
        if (!first) json << ",";
        first = false;
        // Escape any quotes in the strings defensively
        std::string name = mod->getName();
        std::string desc = mod->getDescription();
        std::string type = mod->getType();
        std::string lang = mod->getLanguage();
        std::string keyText = mod->getKeyText();
        // Simple quote escaping
        auto escape = [](std::string s) {
            std::string out;
            for (char c : s) {
                if (c == '"')  out += "\\\"";
                else if (c == '\\') out += "\\\\";
                else out += c;
            }
            return out;
        };
        json << "{"
             << "\"name\":\"" << escape(name) << "\","
             << "\"description\":\"" << escape(desc) << "\","
             << "\"type\":\"" << escape(type) << "\","
             << "\"language\":\"" << escape(lang) << "\","
             << "\"keyText\":\"" << escape(keyText) << "\""
             << "}";
    }
    json << "]";
    return alloc_string(json.str());
}

// Looks up a single verse by module name and OSIS key (e.g. "John 3:16").
// Returns the verse text as a plain UTF-8 string.
// Returns an empty string if the module or key is not found.
// Caller must free with sword_free_string().
__declspec(dllexport)
char* sword_get_verse(const char* module_name, const char* osis_key) {
    // 1. Safety check parameters
    if (!g_mgr || !module_name || !osis_key) {
        return alloc_string("BRIDGE_ERROR: Null pointer passed to native bridge.");
    }
    
    // 2. Fetch the module cleanly from the manager
    sword::SWModule* mod = g_mgr->getModule(module_name);
    if (!mod) {
        return alloc_string("BRIDGE_ERROR: Module not found in g_mgr.");
    }
    
    try {
        // 3. Tell SWORD to point its internal index to the requested verse (e.g., "Gen.1.1")
        mod->setKey(osis_key);
        
        // 4. Use renderText() instead of getRawEntry()
        // This forces SWORD to safely extract the verse from the 1.36MB pool
        sword::SWBuf rendered = mod->renderText();
        
        // 5. Verify we actually got text back
        if (rendered.length() > 0) {
            return alloc_string(rendered.c_str());
        } else {
            return alloc_string("BRIDGE_WARNING: Verse found, but content is empty.");
        }
    } 
    catch (const std::exception& e) {
        std::string err = "BRIDGE_EXCEPTION: std::exception occurred: ";
        err += e.what();
        return alloc_string(err.c_str());
    }
    catch (...) {
        return alloc_string("BRIDGE_EXCEPTION: An unhandled native exception occurred.");
    }
}

// Returns the number of verses in a given book for a Bible module.
// book: OSIS book name e.g. "John", "Gen", "Rev"
// Returns -1 if the module is not found or is not a Bible.
__declspec(dllexport)
int sword_verse_count(const char* module_name, const char* book) {
    if (!g_mgr || !module_name || !book) return -1;
    sword::SWModule* mod = g_mgr->getModule(module_name);
    if (!mod) return -1;
    try {
        sword::VerseKey* vk = dynamic_cast<sword::VerseKey*>(mod->getKey());
        if (!vk) return -1;
        vk->setBookName(book);
        return vk->getChapterMax();
    } catch (...) {
        return -1;
    }
}

// Frees a string previously returned by this bridge.
// Safe to call with nullptr.
__declspec(dllexport)
void sword_free_string(char* ptr) {
    if (ptr) free(ptr);
}

// Shuts down the engine and releases all memory.
// Call this when the app is closing.
__declspec(dllexport)
void sword_shutdown() {
    if (g_mgr) {
        delete g_mgr;
        g_mgr = nullptr;
    }
}

} // extern "C"