import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/state/fullscreen_cubit.dart';
import '../../../../../app/state/interface_visibility_cubit.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/domain/entities/bible_book.dart';
import '../../../../../shared/domain/services/book_resolver.dart';
import '../../../../../shared/widgets/dropdown_menu_anchor.dart';
import '../../../../shortcuts/domain/models/app_command.dart';
import '../../../../shortcuts/presentation/models/app_command_shortcuts.dart';
import '../../../../shortcuts/presentation/widgets/keycap.dart';
import '../../../../shortcuts/presentation/widgets/shortcut_view.dart';
import '../../../../shortcuts/presentation/widgets/shortcuts_focus_scope.dart';
import '../state/search_bloc.dart';

// note: I have commented out the empty canidates state for the suggestion list

typedef BSearchSuggestion = BibleBook;

class BSearchbar extends StatefulWidget {
  const BSearchbar({
    this.onSubmitted,
    this.height = 42,
    this.width = 280,
    this.isDense = false,
    super.key,
    this.theme,
  });

  final Function()? onSubmitted;
  final double height;
  final double width;
  final bool isDense;
  final SearchBarThemeData? theme;

  @override
  State<BSearchbar> createState() => _BSearchbarState();
}

class _BSearchbarState extends State<BSearchbar> {
  final _ctrl = TextEditingController();
  FocusNode? _focusNode;

  final _bookResolver = di.sl.get<BookResolver>();

  final _menuVisible = ValueNotifier<bool>(false);

  List<BSearchSuggestion> _candidates = [];
  int _highlightedIndex = -1;
  Timer? _debounce;
  bool _suppressNextQueryChange = false;

  static const _itemHeight = 42.0;
  static const _maxVisibleItems = 6;

  double get _menuHeight {
    // if (_candidates.isEmpty) return _itemHeight; // "No matching books" row
    return _candidates.length.clamp(1, _maxVisibleItems) * _itemHeight;
  }

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onQueryChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final node = ShortcutFocusScope.of(context).search;
    if (_focusNode != node) {
      _focusNode?.removeListener(_onFocusChange);
      _focusNode = node..addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (_focusNode!.hasFocus) {
      if (_ctrl.text.isNotEmpty) {
        _ctrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _ctrl.text.length,
        );
      }
    } else {
      _menuVisible.value = false;
    }
  }

  void _onQueryChanged() {
    if (_suppressNextQueryChange) {
      _suppressNextQueryChange = false;
      return;
    }

    _debounce?.cancel();
    final query = _ctrl.text;

    if (query.trim().isEmpty) {
      _applyCandidates(const []);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 120), () async {
      final results = await _bookResolver.resolveCandidates(query, 0);
      _applyCandidates(results);
    });
  }

  void _applyCandidates(List<BSearchSuggestion> results) {
    if (!mounted) return;
    setState(() {
      _candidates = results;
      _highlightedIndex = results.isEmpty ? -1 : 0;
    });

    final hasQuery = _ctrl.text.trim().isNotEmpty;
    final isFocused = _focusNode?.hasFocus ?? false;
    _menuVisible.value = isFocused && hasQuery && _candidates.isNotEmpty;
  }

  void _moveHighlight(int delta) {
    if (_candidates.isEmpty) return;
    setState(() {
      _highlightedIndex = (_highlightedIndex + delta) % _candidates.length;
    });
  }

  void _selectCandidate(BSearchSuggestion candidate) {
    _debounce?.cancel();
    _suppressNextQueryChange = true;
    // also add a space at the end
    _ctrl.value = TextEditingValue(
      text: '${candidate.englishName} ',
      selection:
          TextSelection.collapsed(offset: candidate.englishName.length + 1),
    );
    _menuVisible.value = false;
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    if (!_menuVisible.value) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _moveHighlight(1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _moveHighlight(-1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.tab) {
      if (_highlightedIndex >= 0 && _highlightedIndex < _candidates.length) {
        _selectCandidate(_candidates[_highlightedIndex]);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _menuVisible.value = false;
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.removeListener(_onQueryChanged);
    _focusNode?.removeListener(_onFocusChange);
    _menuVisible.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final popupTheme = Theme.of(context).popupMenuTheme;

    return Focus(
      onKeyEvent: _handleKey,
      skipTraversal: true,
      canRequestFocus: false,
      child: DropdownMenuAnchor(
        // this is redundant; It is only to specify it for later
        // when it is added to the menu height
        menuPadding: popupTheme.menuPadding,
        menuVisible: _menuVisible,
        menuWidth: widget.width,
        menuHeight: _menuHeight + (popupTheme.menuPadding!.vertical / 2),
        menuAlignment: Alignment.topLeft,
        trigger: BlocConsumer<SearchBloc, SearchState>(
          listenWhen: (prev, curr) =>
              prev.errorCount != curr.errorCount && curr.errorCount > 0,
          listener: (context, state) {
            if (state is! SearchError) return;
            final isFullscreen = context.read<FullscreenCubit>().state;
            final showMenuBar =
                context.read<InterfaceVisibilityCubit>().state.isToolbarVisible;
            if (!isFullscreen || showMenuBar) return;
          },
          buildWhen: (prev, curr) =>
              prev.errorCount != curr.errorCount && curr.errorCount > 0,
          builder: (context, state) {
            return _SearchBarWithErrorFeedback(
              hasError: state is SearchError,
              errorTrigger: state.errorCount,
              child: SearchBar(
                // theme overwrites
                backgroundColor: widget.theme?.backgroundColor,
                side: widget.theme?.side,
                //
                controller: _ctrl,
                constraints: BoxConstraints(
                    maxWidth: widget.width, minHeight: widget.height),
                focusNode: _focusNode,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(Icons.search,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                hintText: 'Search reference',
                elevation: const WidgetStatePropertyAll(0),
                trailing: [
                  if (_focusNode != null)
                    ListenableBuilder(
                      listenable: _focusNode!,
                      builder: (context, __) {
                        if (_focusNode!.hasFocus) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          alignment: AlignmentDirectional.centerEnd,
                          child: ShortcutView(
                            activator:
                                appCommandShortcuts[AppCommand.focusSearch],
                            textColor:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fillColor: Colors.transparent,
                            borderColor: null,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                ],
                onSubmitted: (input) {
                  if (widget.onSubmitted != null) widget.onSubmitted!();
                  if (input.isEmpty) return;
                  BlocProvider.of<SearchBloc>(context)
                      .add(SearchParseIntent(input));
                },
              ),
            );
          },
        ),
        menuContent: _SuggestionsList(
          candidates: _candidates,
          highlightedIndex: _highlightedIndex,
          onSelected: _selectCandidate,
          onHover: (i) => setState(() => _highlightedIndex = i),
        ),
      ),
    );
  }
}

// ========================================================
// Error visuals
// ========================================================
class _SearchBarWithErrorFeedback extends StatefulWidget {
  const _SearchBarWithErrorFeedback({
    required this.child,
    required this.errorTrigger,
    required this.hasError,
  });

  final Widget child;
  final int errorTrigger; // increments on each new error
  final bool hasError;

  @override
  State<_SearchBarWithErrorFeedback> createState() =>
      _SearchBarWithErrorFeedbackState();
}

class _SearchBarWithErrorFeedbackState
    extends State<_SearchBarWithErrorFeedback>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _progress = TweenSequence<double>([
      // Beep 1 — fade in
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 13,
      ),
      // Beep 1 — hold
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 15),
      // Beep 1 — fade out
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 13,
      ),
      // Gap between beeps
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 11),
      // Beep 2 — fade in
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 13,
      ),
      // Beep 2 — hold
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 15),
      // Beep 2 — fade out (longer tail)
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(_SearchBarWithErrorFeedback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorTrigger != oldWidget.errorTrigger &&
        widget.errorTrigger > 0) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    final borderRadius = AppRadius.input; // match SearchBar's

    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: _progress.value <= 1.0
              ? _BorderProgressPainter(
                  progress: _progress.value,
                  color: errorColor,
                  borderRadius: borderRadius,
                  strokeWidth: 2.0,
                )
              : null,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _BorderProgressPainter extends CustomPainter {
  const _BorderProgressPainter({
    required this.progress,
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final BorderRadius borderRadius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rrect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_BorderProgressPainter old) =>
      old.progress != progress || old.color != color;
}

// ========================================================
// Suggestions / Candidates overaly
// ========================================================
class _SuggestionsList extends StatelessWidget {
  const _SuggestionsList({
    required this.candidates,
    required this.highlightedIndex,
    required this.onSelected,
    required this.onHover,
  });

  final List<BSearchSuggestion> candidates;
  final int highlightedIndex;
  final ValueChanged<BSearchSuggestion> onSelected;
  final ValueChanged<int> onHover;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // if (candidates.isEmpty) {
    //   return Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    //     child: Text(
    //       'No matching books',
    //       style: theme.textTheme.bodySmall
    //           ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
    //     ),
    //   );
    // }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: candidates.length,
      itemBuilder: (context, index) {
        final candidate = candidates[index];
        final isHighlighted = index == highlightedIndex;
        return MouseRegion(
          hitTestBehavior: HitTestBehavior.opaque,
          onEnter: (_) => onHover(index),
          child: InkWell(
            canRequestFocus: false,
            onTap: () => onSelected(candidate),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? theme.colorScheme.primary.withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                spacing: AppSpacing.sm,
                children: [
                  Expanded(
                    child: Text(candidate.englishName,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text(candidate.canonical,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                  if (isHighlighted) const Keycap('tab', fontSize: 10)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
