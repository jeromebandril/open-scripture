import 'dart:convert';

import '../enums/remote_command_type.dart';

class RemoteCommand {
  final String? requestId;
  final String? clientId;
  final RemoteCommandType type;
  final String? name;
  final String? target;
  final Map<String, dynamic>? payload;

  const RemoteCommand({
    this.requestId,
    this.clientId,
    required this.type,
    this.name,
    this.target,
    this.payload,
  });

  factory RemoteCommand.fromJson(Map<String, dynamic> json) {
    return RemoteCommand(
      requestId: json['request_id'] as String?,
      clientId: json['client_id'] as String?,
      type: _parseType(json['type']),
      name: json['command'] as String?,
      target: json['target'] as String?,
      payload: (json['payload'] as Map?)?.cast<String, dynamic>(),
    );
  }

  factory RemoteCommand.fromRaw(String raw) {
    final Map<String, dynamic> json = jsonDecode(raw);
    return RemoteCommand.fromJson(json);
  }

  static RemoteCommandType _parseType(dynamic value) {
    if (value is String) {
      return RemoteCommandType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => RemoteCommandType.command,
      );
    }
    return RemoteCommandType.command;
  }

  Map<String, dynamic> toJson() {
    return {
      if (clientId != null) 'client_id': clientId,
      if (requestId != null) 'request_id': requestId,
      'type': type.name,
      if (name != null) 'command': name,
      if (target != null) 'target': target,
      if (payload != null) 'payload': payload,
    };
  }

  String toRaw() {
    return jsonEncode(toJson());
  }
}
