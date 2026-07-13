import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Native function signatures
typedef _SwordInitNative = Int32 Function(Pointer<Utf8> modulePath);
typedef _SwordInitDart = int Function(Pointer<Utf8> modulePath);

typedef _SwordListModulesNative = Pointer<Utf8> Function();
typedef _SwordListModulesDart = Pointer<Utf8> Function();

typedef _SwordListBiblesNative = Pointer<Utf8> Function();
typedef _SwordListBiblesDart = Pointer<Utf8> Function();

typedef _SwordGetVerseNative = Pointer<Utf8> Function(
    Pointer<Utf8> moduleName, Pointer<Utf8> osisKey);
typedef _SwordGetVerseDart = Pointer<Utf8> Function(
    Pointer<Utf8> moduleName, Pointer<Utf8> osisKey);

typedef _SwordGetChapterNative = Pointer<Utf8> Function(
    Pointer<Utf8> moduleName, Pointer<Utf8> book, Int32 chapter);
typedef _SwordGetChapterDart = Pointer<Utf8> Function(
    Pointer<Utf8> moduleName, Pointer<Utf8> book, int chapter);

typedef _SwordVerseCountNative = Int32 Function(
    Pointer<Utf8> moduleName, Pointer<Utf8> book);
typedef _SwordVerseCountDart = int Function(
    Pointer<Utf8> moduleName, Pointer<Utf8> book);

typedef _SwordFreeStringNative = Void Function(Pointer<Utf8> ptr);
typedef _SwordFreeStringDart = void Function(Pointer<Utf8> ptr);

typedef _SwordShutdownNative = Void Function();
typedef _SwordShutdownDart = void Function();

typedef _SwordGetModuleInfoNative = Pointer<Utf8> Function(
    Pointer<Utf8> moduleName);
typedef _SwordGetModuleInfoDart = Pointer<Utf8> Function(
    Pointer<Utf8> moduleName);

class SwordBridge {
  late final _SwordInitDart _init;
  late final _SwordListModulesDart _listModules;
  late final _SwordListBiblesDart _listBibles;
  late final _SwordGetVerseDart _getVerse;
  late final _SwordGetChapterDart _getChapter;
  late final _SwordVerseCountDart _verseCount;
  late final _SwordFreeStringDart _freeString;
  late final _SwordShutdownDart _shutdown;
  late final _SwordGetModuleInfoDart _getModuleInfo;

  SwordBridge._() {
    final lib = DynamicLibrary.open('native_sword_bridge.dll');

    _init = lib.lookupFunction<_SwordInitNative, _SwordInitDart>('sword_init');
    _listModules =
        lib.lookupFunction<_SwordListModulesNative, _SwordListModulesDart>(
            'sword_list_modules');
    _listBibles =
        lib.lookupFunction<_SwordListBiblesNative, _SwordListBiblesDart>(
            'sword_list_bibles');
    _getVerse = lib.lookupFunction<_SwordGetVerseNative, _SwordGetVerseDart>(
        'sword_get_verse');
    _getChapter =
        lib.lookupFunction<_SwordGetChapterNative, _SwordGetChapterDart>(
            'sword_get_chapter');
    _verseCount =
        lib.lookupFunction<_SwordVerseCountNative, _SwordVerseCountDart>(
            'sword_verse_count');
    _freeString =
        lib.lookupFunction<_SwordFreeStringNative, _SwordFreeStringDart>(
            'sword_free_string');
    _shutdown = lib.lookupFunction<_SwordShutdownNative, _SwordShutdownDart>(
        'sword_shutdown');
    _getModuleInfo =
        lib.lookupFunction<_SwordGetModuleInfoNative, _SwordGetModuleInfoDart>(
            'sword_get_module_info');
  }

  static SwordBridge? create(String modulePath) {
    final bridge = SwordBridge._();

    final pathPtr = modulePath.toNativeUtf8();
    try {
      final isSuccess = bridge._init(pathPtr) == 1;
      if (isSuccess) return bridge;
      return null;
    } finally {
      malloc.free(pathPtr);
    }
  }

  String listModules() {
    final ptr = _listModules();
    try {
      return ptr.toDartString();
    } finally {
      _freeString(ptr);
    }
  }

  /// Returns a JSON string listing only installed Bible modules.
  String listBibles() {
    final ptr = _listBibles();
    try {
      return ptr.toDartString();
    } finally {
      _freeString(ptr);
    }
  }

  String getModuleInfo(String moduleName) {
    final namePtr = moduleName.toNativeUtf8();
    try {
      final ptr = _getModuleInfo(namePtr);
      try {
        return ptr.toDartString();
      } finally {
        _freeString(ptr);
      }
    } finally {
      malloc.free(namePtr);
    }
  }

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

  /// Returns a JSON string containing all verses in a chapter.
  /// Format: [{"verse": 1, "text": "..."}]
  String getChapter(String moduleName, String book, int chapter) {
    final modPtr = moduleName.toNativeUtf8();
    final bookPtr = book.toNativeUtf8();
    try {
      final result = _getChapter(modPtr, bookPtr, chapter);
      try {
        return result.toDartString();
      } finally {
        _freeString(result);
      }
    } finally {
      malloc.free(modPtr);
      malloc.free(bookPtr);
    }
  }

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

  void shutdown() => _shutdown();
}
