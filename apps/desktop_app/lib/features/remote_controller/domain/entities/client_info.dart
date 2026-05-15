import 'package:equatable/equatable.dart';

typedef ClientId = String;

class ClientInfo extends Equatable {
  final ClientId id;
  final String ipAdress;
  final String deviceName;

  const ClientInfo({
    required this.id,
    required this.ipAdress,
    required this.deviceName,
  });

  @override
  List<Object?> get props => [id, ipAdress, deviceName];
}
