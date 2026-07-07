import 'package:flutter/material.dart';

/// Resolves a GetIt singleton — sync or async registration, doesn't matter —
/// and hands it to [builder] once ready.
class AsyncSingletonBuilder<T extends Object> extends StatefulWidget {
  final Future<T> Function() resolver;
  final Widget Function(BuildContext context, T value) builder;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext context, Object error, VoidCallback retry)?
      errorBuilder;

  const AsyncSingletonBuilder({
    super.key,
    required this.resolver,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  State<AsyncSingletonBuilder<T>> createState() =>
      _AsyncSingletonBuilderState<T>();
}

class _AsyncSingletonBuilderState<T extends Object>
    extends State<AsyncSingletonBuilder<T>> {
  late Future<T> _future = widget.resolver();

  void _retry() => setState(() => _future = widget.resolver());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.errorBuilder?.call(context, snapshot.error!, _retry) ??
              const SizedBox.shrink();
        }
        if (!snapshot.hasData) {
          return widget.loadingBuilder?.call(context) ??
              const Center(child: CircularProgressIndicator());
        }
        return widget.builder(context, snapshot.data as T);
      },
    );
  }
}
