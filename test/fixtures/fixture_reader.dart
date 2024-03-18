import 'dart:io';
import 'dart:typed_data';

String fixture(String name) =>
    File('test/fixtures/usfx/eng-kjv/$name').readAsStringSync();

Uint8List fixtureZip(String name) =>
    File('test/fixtures/$name').readAsBytesSync();
