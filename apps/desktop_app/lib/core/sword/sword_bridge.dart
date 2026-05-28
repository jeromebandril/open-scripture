import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Native function signatures

typedef _SwordInitNative = Int32 Function(Pointer<Utf8> modulePath);
typedef _SwordInitDart = int Function(Pointer<Utf8> modulePath);

typedef _SwordListModulesNative = Pointer<Utf8> Function();
typedef _SwordListModulesDart = Pointer<Utf8> Function();

typedef _SwordGetVerseNative = Pointer<Utf8> Function(
    Pointer<Utf8> moduleName, Pointer<Utf8> osisKey);
typedef _SwordGetVerseDart = Pointer<Utf8> Function(
    Pointer<Utf8> moduleName, Pointer<Utf8> osisKey);

typedef _SwordVerseCountNative = Int32 Function(
    Pointer<Utf8> moduleName, Pointer<Utf8> book);
typedef _SwordVerseCountDart = int Function(
    Pointer<Utf8> moduleName, Pointer<Utf8> book);

typedef _SwordFreeStringNative = Void Function(Pointer<Utf8> ptr);
typedef _SwordFreeStringDart = void Function(Pointer<Utf8> ptr);

typedef _SwordShutdownNative = Void Function();
typedef _SwordShutdownDart = void Function();

// Bridge class

class SwordBridge {
  late final _SwordInitDart _init;
  late final _SwordListModulesDart _listModules;
  late final _SwordGetVerseDart _getVerse;
  late final _SwordVerseCountDart _verseCount;
  late final _SwordFreeStringDart _freeString;
  late final _SwordShutdownDart _shutdown;

  SwordBridge() {
    final lib = DynamicLibrary.open('native_sword_bridge.dll');

    _init = lib.lookupFunction<_SwordInitNative, _SwordInitDart>('sword_init');
    _listModules =
        lib.lookupFunction<_SwordListModulesNative, _SwordListModulesDart>(
            'sword_list_modules');
    _getVerse = lib.lookupFunction<_SwordGetVerseNative, _SwordGetVerseDart>(
        'sword_get_verse');
    _verseCount =
        lib.lookupFunction<_SwordVerseCountNative, _SwordVerseCountDart>(
            'sword_verse_count');
    _freeString =
        lib.lookupFunction<_SwordFreeStringNative, _SwordFreeStringDart>(
            'sword_free_string');
    _shutdown = lib.lookupFunction<_SwordShutdownNative, _SwordShutdownDart>(
        'sword_shutdown');
  }

  /// Call once at app startup with the path to your modules directory.
  /// Returns true on success.
  bool init(String modulePath) {
    final pathPtr = modulePath.toNativeUtf8();
    try {
      return _init(pathPtr) == 1;
    } finally {
      malloc.free(pathPtr);
    }
  }

  /// Returns a JSON string listing all installed modules.
  String listModules() {
    final ptr = _listModules();
    try {
      return ptr.toDartString();
    } finally {
      _freeString(ptr);
    }
  }

  /// Returns the plain text of a verse.
  /// [moduleName] e.g. "KJV"
  /// [osisKey]    e.g. "John 3:16"
  String getVerse(String moduleName, String osisKey) {
    final modPtr = moduleName.toNativeUtf8();
    final keyPtr = osisKey.toNativeUtf8();
    try {
      final result = _getVerse(modPtr, keyPtr);
      try {
        return result.toDartString();
      } finally {
        _freeString(result);
      }
    } finally {
      malloc.free(modPtr);
      malloc.free(keyPtr);
    }
  }

  /// Returns the number of chapters in a book, or -1 if not found.
  int verseCount(String moduleName, String book) {
    final modPtr = moduleName.toNativeUtf8();
    final bookPtr = book.toNativeUtf8();
    try {
      return _verseCount(modPtr, bookPtr);
    } finally {
      malloc.free(modPtr);
      malloc.free(bookPtr);
    }
  }

  /// Call when the app is closing.
  void shutdown() => _shutdown();
}
