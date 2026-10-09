import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../../../shared/presentation/models/display_option_flutter.dart';
import '../../domain/entities/slide_data.dart';
import '../../settings/presenter_settings.dart';

class Slide extends StatelessWidget {
  const Slide({super.key, required this.data});

  final SlideData data;

  @override
  Widget build(BuildContext context) {
    final settings = context.select((SettingsCubit<PresenterSettings> s) => (
          textColor: s.state.textColor,
          titleFontWeight: s.state.titleFontWeight,
          subtitleFontWeight: s.state.subtitleFontWeight
        ));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 64,
              color: settings.textColor,
              fontWeight: settings.titleFontWeight.toFlutter(),
              height: 1.1,
            ),
          ),
          if (data.subtitle != null)
            Text(
              data.subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42,
                fontWeight: settings.subtitleFontWeight.toFlutter(),
                color: settings.textColor,
                height: 1.1,
              ),
            )
        ],
      ),
    );
  }
}
