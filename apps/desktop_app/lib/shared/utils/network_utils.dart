import 'dart:io';

class NetworkUtils {
  static Future<String> getLocalIp() async {
    final interfaces =
        await NetworkInterface.list(type: InternetAddressType.IPv4);
    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          return addr.address;
        }
      }
    }
    throw 'No local IP found';
  }
}
