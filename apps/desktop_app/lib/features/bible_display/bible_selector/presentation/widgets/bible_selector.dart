import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/core/di/injection_container.dart' as di;
import 'package:open_scripture/features/bible_display/bible_selector/presentation/cubit/bible_selector_cubit.dart';
import 'package:open_scripture/features/bible_installer_manager/presentation/state/installer/installer_bloc.dart';
import 'package:open_scripture/features/customizer/presentation/state/customizer_cubit.dart';
import 'package:open_scripture/features/my_library/presentation/cubit/my_library_cubit.dart';

import '../../../../customizer/presentation/models/bible_pane_general_theme.dart';

class BibleSelector extends StatelessWidget {
  final void Function(List<int> selectedBibleId) onConfirm;
  final BibleSelectorCubit? bloc;

  const BibleSelector({required this.onConfirm, this.bloc, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc ?? di.sl<BibleSelectorCubit>(),
      child: _BibleSelectorBody(onConfirm: onConfirm),
    );
  }
}

class _BibleSelectorBody extends StatelessWidget {
  final void Function(List<int> selectedBibleId) onConfirm;

  const _BibleSelectorBody({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final useCustom = context.select(
      (CustomizerCubit b) => b.state.pane.enableCustomTheme,
    );
    final paneTheme = Theme.of(context).extension<BiblePaneGeneralTheme>()!;
    // final height = MediaQuery.sizeOf(context).height;

    final selectedIds = context.select(
      (BibleSelectorCubit b) => b.state.selectedBiblesIds,
    );

    return BlocBuilder<MyLibraryCubit, MyLibraryState>(
      builder: (context, state) {
        Widget body;
        switch (state.status) {
          case MyLibraryStatus.loading || MyLibraryStatus.initial:
            body = const Center(child: CircularProgressIndicator());
            break;

          case MyLibraryStatus.error:
            body = Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Failed to load bibles'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    //context.read<BibleSelectorBloc>().add(const BibleSelectorRetry()),
                    onPressed: () => print('Retry'),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
            break;

          case MyLibraryStatus.ready:
            if (state.bibles.isEmpty) {
              body = Text('Go to <Settings> to install a bible',
                  textAlign: TextAlign.center);
              break;
            }

            body = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(' Select bibles',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: useCustom
                          ? paneTheme.textColor
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(height: 18),
                Theme(
                  data: Theme.of(context)
                      .copyWith(splashFactory: NoSplash.splashFactory),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 500),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.bibles.length,
                      itemBuilder: (context, index) {
                        final bible = state.bibles[index];
                        final selected = selectedIds.contains(bible.id);
                        final style = TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        );

                        return Card(
                          clipBehavior: Clip.hardEdge,
                          child: ListTile(
                              selected: selected,
                              title: Text(bible.bibleNameLocal, style: style),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bible.abbreviation,
                                    style: style,
                                  ),
                                  Text(
                                    bible.langEngName ??
                                        bible.langNativeName ??
                                        bible.langIsoCode ??
                                        '',
                                    style: style.copyWith(
                                        color: style.color!.withAlpha(125)),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: selected
                                  ? Text(
                                      '${selectedIds.indexOf(bible.id!) + 1}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24,
                                      ),
                                    )
                                  : null,
                              onTap: () => context
                                  .read<BibleSelectorCubit>()
                                  .select(bible.id!)),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: selectedIds.isEmpty
                          ? null
                          : () => onConfirm(selectedIds),
                      autofocus: true,
                      child: const SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4,
                          children: [
                            Text('Confirm'),
                            Icon(Icons.arrow_forward_rounded)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
            break;
        }
        return Center(
          child: SizedBox(width: 400, child: body),
        );
      },
    );
  }
}
