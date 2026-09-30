enum NotificationType {
  info,
  success,
  warning,
  error,
}

class NotificationData {
  const NotificationData({
    required this.message,
    this.title,
    this.type = NotificationType.info,
    this.duration = const Duration(seconds: 3),
  });

  final String message;
  final String? title;
  final NotificationType type;
  final Duration duration;
}
