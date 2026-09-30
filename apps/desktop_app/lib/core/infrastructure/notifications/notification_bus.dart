import '../event_bus/event_bus.dart';
import 'notification_data.dart';

class NotificationBus extends EventBus<NotificationData> {
  void show(NotificationData notification) => emit(notification);

  void info(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) =>
      show(NotificationData(
        message: message,
        title: title,
        type: NotificationType.info,
        duration: duration,
      ));

  void success(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) =>
      show(NotificationData(
        message: message,
        title: title,
        type: NotificationType.success,
        duration: duration,
      ));

  void warning(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) =>
      show(NotificationData(
        message: message,
        title: title,
        type: NotificationType.warning,
        duration: duration,
      ));

  void error(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 5),
  }) =>
      show(NotificationData(
        message: message,
        title: title,
        type: NotificationType.error,
        duration: duration,
      ));
}
