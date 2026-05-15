import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

typedef DeviceIdentity = ({String id, String name});

class DeviceIdentityService {
  static const _keyId = 'device_id';
  static const _keyName = 'device_name';

  static Future<DeviceIdentity> get() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getString(_keyId) ?? await _generateId(prefs);
    final name = prefs.getString(_keyName) ?? await _resolveDeviceName(prefs);

    return (id: id, name: name);
  }

  static Future<String> _generateId(SharedPreferences prefs) async {
    final id = const Uuid().v4();
    await prefs.setString(_keyId, id);
    return id;
  }

  static Future<String> _resolveDeviceName(SharedPreferences prefs) async {
    final info = await DeviceInfoPlugin().androidInfo;
    final name = info.model;
    await prefs.setString(_keyName, name);
    return name;
  }
}
