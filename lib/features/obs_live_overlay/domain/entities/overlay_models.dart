import 'dart:convert';

import 'package:equatable/equatable.dart';

typedef OverlayId = String;

class OverlaySnapshot extends Equatable {
  final Map<OverlayId, OverlayItem> items;

  const OverlaySnapshot({required this.items});

  OverlaySnapshot copyWithItem(OverlayId id, OverlayItem item) {
    final next = Map<OverlayId, OverlayItem>.from(items);
    next[id] = item;
    return OverlaySnapshot(items: next);
  }

  Map<String, dynamic> toJson() => {
        'items': items.map((k, v) => MapEntry(k, v.toJson())),
      };

  static OverlaySnapshot initial() => const OverlaySnapshot(items: {
        'ref': OverlayItem(text: '', visible: false),
        'content': OverlayItem(text: '', visible: false),
      });

  @override
  List<Object?> get props => [items];
}

class WsMsg {
  final String type;
  final Map<String, dynamic> data;

  WsMsg(this.type, [Map<String, dynamic>? data]) : data = data ?? {};

  String encode() => jsonEncode({'type': type, ...data});

  static Map<String, dynamic> decode(String raw) =>
      jsonDecode(raw) as Map<String, dynamic>;
}

class OverlayItem extends Equatable {
  final String text;
  final bool visible;

  const OverlayItem({required this.text, required this.visible});

  OverlayItem copyWith({String? text, bool? visible}) => OverlayItem(
        text: text ?? this.text,
        visible: visible ?? this.visible,
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'visible': visible,
      };

  static OverlayItem fromJson(Map<String, dynamic> json) => OverlayItem(
        text: (json['text'] ?? '') as String,
        visible: (json['visible'] ?? true) as bool,
      );

  @override
  List<Object?> get props => [text, visible];
}
