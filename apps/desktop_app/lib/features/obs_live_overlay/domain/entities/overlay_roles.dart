enum ClientRole {
  overlay,
  controller,
  desktop;

  static ClientRole? fromWire(String? value) {
    if (value == null) return null;
    for (final role in ClientRole.values) {
      if (role.name == value) return role;
    }
    return null;
  }
}
