import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/presenter_cubit.dart';
import '../widgets/slides_editor.dart';

class PresenterSetupPage extends StatelessWidget {
  const PresenterSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: BlocBuilder<PresenterCubit, PresenterState>(
        builder: (context, state) {
          return SlidesEditor(
            onApply: (val) => context.read<PresenterCubit>().updateSlides(val),
            initialSlides: state.slides,
          );
        },
      ),
    );
  }
}
