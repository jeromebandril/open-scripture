#include <windows.h>

extern "C" {

__declspec(dllexport)
const char* sword_version() {
    return "bridge_ok_v0.1";
}

}