import 'package:shared/models/remote_command_type.dart';

class RemoteCommand {
  final String id;
  final RemoteCommandType type;
  final String target;
  final Map<String, dynamic> payload;

  const RemoteCommand({
    required this.id,
    required this.type,
    required this.target,
    required this.payload,
  });

  RemoteCommand.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      type = RemoteCommandType.values.firstWhere(
        (e) => e.toString() == 'CommandType.${json['type']}',
        orElse: () => RemoteCommandType.action,
      ),
      target = json['target'] as String,
      payload = json['payload'] as Map<String, dynamic>;
}
