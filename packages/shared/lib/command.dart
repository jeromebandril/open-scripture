class Command {
  final String type;
  final Map<String, dynamic> payload;

  Command(this.type, this.payload);

  Map<String, dynamic> toJson() => {'type': type, 'payload': payload};

  factory Command.fromJson(Map<String, dynamic> json) {
    return Command(json['type'], Map<String, dynamic>.from(json['payload']));
  }
}
