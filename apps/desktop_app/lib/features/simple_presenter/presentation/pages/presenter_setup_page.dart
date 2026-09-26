import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/extensions/build_context_extensions.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/settings/settings_cubit.dart';
import '../../settings/presenter_settings.dart';
import '../cubit/presenter_cubit.dart';
import '../widgets/slides_editor.dart';

class PresenterSetupPage extends StatelessWidget {
  const PresenterSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<SettingsCubit<PresenterSettings>>(),
      child: BlocBuilder<PresenterCubit, PresenterState>(
        builder: (context, state) {
          return SlidesEditor(
            onApply: (val) {
              context.read<PresenterCubit>().updateSlides(val);
              context.closeWindow();
            },
            initialSlides: state.slides,
          );
        },
      ),
    );
  }
}
