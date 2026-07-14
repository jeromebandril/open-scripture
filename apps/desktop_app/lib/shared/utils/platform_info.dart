import 'package:flutter/foundation.dart';

String getTargetPlatform() {
  final platform = switch (defaultTargetPlatform) {
    TargetPlatform.windows => 'Windows',
    TargetPlatform.macOS => 'macOS',
    TargetPlatform.linux => 'Linux',
    TargetPlatform.android => 'Android',
    TargetPlatform.iOS => 'iOS',
    TargetPlatform.fuchsia => 'Fuchsia',
  };

  final target = kIsWeb ? 'Web' : platform;

  return target;
}
