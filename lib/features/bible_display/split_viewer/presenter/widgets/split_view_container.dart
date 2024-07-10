import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/split_viewer/presenter/bloc/split_viewer_bloc.dart';

class SplitViewContainer extends StatelessWidget {
  final Widget child;

  const SplitViewContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplitViewerBloc, SplitViewerState>(
      builder: (context, state),
    );
  }
}
