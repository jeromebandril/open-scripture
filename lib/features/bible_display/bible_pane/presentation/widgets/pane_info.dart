import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_pane/presentation/bloc/bible_pane_bloc.dart';

class PaneInfo extends StatefulWidget {
  const PaneInfo({super.key});

  @override
  State<PaneInfo> createState() => _PaneInfoState();
}

class _PaneInfoState extends State<PaneInfo> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bibleMeta = context.select(
      (BiblePaneBloc b) => b.state.bibleMeta, // ideally Set<String>s
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() {
          isExpanded = !isExpanded;
        }),
        child: Container(
          margin: EdgeInsets.all(4),
          height: 25,
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            children: [
              Text(
                bibleMeta == null
                    ? 'Unknown'
                    : isExpanded
                        ? '${bibleMeta.extId} — ${bibleMeta.bibleName} — ${bibleMeta.langEngName}'
                        : bibleMeta.abbreviation,
              )
            ],
          ),
        ),
      ),
    );
  }
}
