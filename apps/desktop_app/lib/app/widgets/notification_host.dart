import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/di/injection_container.dart' as di;
import '../../core/infrastructure/notifications/notification_bus.dart';
import '../../core/infrastructure/notifications/notification_data.dart';
import '../../shared/design_system/design_system.dart';

class _NotificationEntry {
  _NotificationEntry(this.notification);
  final NotificationData notification;
  Timer? timer;
}

class NotificationHost extends StatefulWidget {
  const NotificationHost({
    super.key,
    this.maxVisible = 3,
    this.alignment = Alignment.topCenter,
    this.top = 24,
    this.right = 24,
    this.left = 24,
    this.spacing = 10,
  });

  final int maxVisible;
  final Alignment alignment;
  final double top;
  final double right;
  final double left;
  final double spacing;

  @override
  State<NotificationHost> createState() => _NotificationHostState();
}

class _NotificationHostState extends State<NotificationHost> {
  final List<_NotificationEntry> _notifications = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  StreamSubscription<NotificationData>? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = di.sl<NotificationBus>().stream.listen(_show);
  }

  void _show(NotificationData notification) {
    if (!mounted) return;

    final entry = _NotificationEntry(notification);

    setState(() {
      _notifications.add(entry);
    });

    _listKey.currentState?.insertItem(
      _notifications.length - 1,
      duration: const Duration(milliseconds: 260),
    );

    if (_notifications.length > widget.maxVisible) {
      final removed = _notifications.removeAt(0);
      removed.timer?.cancel();

      _listKey.currentState?.removeItem(
        0,
        (context, animation) => _buildAnimatedItem(
          context,
          removed,
          animation,
        ),
        duration: const Duration(milliseconds: 180),
      );
    }

    entry.timer = Timer(notification.duration, () => _dismiss(entry));
  }

  void _dismiss(_NotificationEntry entry) {
    if (!mounted || !_notifications.contains(entry)) return;

    entry.timer?.cancel();

    final index = _notifications.indexOf(entry);
    if (index == -1) return;

    entry.timer?.cancel();

    final removed = _notifications.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildAnimatedItem(context, removed, animation),
      duration: const Duration(milliseconds: 220),
    );
  }

  Widget _buildAnimatedItem(
    BuildContext context,
    _NotificationEntry entry,
    Animation<double> animation,
  ) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      ),
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.spacing),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: _NotificationCard(
              key: ValueKey(entry),
              notification: entry.notification,
              onDismiss: () => _dismiss(entry),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();

    for (final notification in _notifications) {
      notification.timer?.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: SafeArea(
          child: Align(
            alignment: widget.alignment,
            child: Padding(
              padding: EdgeInsets.only(
                top: widget.top,
                right: widget.right,
                left: widget.left,
              ),
              child: AnimatedList(
                key: _listKey,
                shrinkWrap: true,
                initialItemCount: _notifications.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index, animation) => _buildAnimatedItem(
                  context,
                  _notifications[index],
                  animation,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  final NotificationData notification;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = colorScheme.onSurface;

    final config = switch (notification.type) {
      NotificationType.info => (
          // color: colorScheme.primary,
          color: colorScheme.surfaceContainerHighest,
          icon: Icons.info_outline_rounded,
        ),
      NotificationType.success => (
          // color: Colors.green.shade600,
          color: colorScheme.surfaceContainerHighest,
          icon: Icons.check_circle_outline_rounded,
        ),
      NotificationType.warning => (
          // color: Colors.orange.shade700,
          color: colorScheme.surfaceContainerHighest,
          icon: Icons.warning_amber_rounded,
        ),
      NotificationType.error => (
          // color: colorScheme.error,
          color: colorScheme.surfaceContainerHighest,
          icon: Icons.error_outline_rounded,
        ),
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 8, 13),
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: config.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(config.icon, color: config.color, size: 18),
          ),
          const SizedBox(width: 11),
          Text(
            notification.message,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.35,
              fontWeight: FontWeight.w500,
              color: colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Dismiss',
            onPressed: onDismiss,
            icon: Icon(
              Icons.close_rounded,
              size: 17,
              color: colorScheme.surfaceContainerHighest,
            ),
          )
        ],
      ),
    );
  }
}
