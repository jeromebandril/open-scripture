import 'package:equatable/equatable.dart';

typedef ClientId = String;

class ClientInfo extends Equatable {
  final ClientId id;
  final String ipAdress;

  const ClientInfo({
    required this.id,
    required this.ipAdress,
  });

  @override
  List<Object?> get props => [id, ipAdress];
}
