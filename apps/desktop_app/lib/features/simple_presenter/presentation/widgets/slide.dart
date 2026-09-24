import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/settings/settings_cubit.dart';
import '../../domain/entities/slide_data.dart';
import '../../settings/presenter_settings.dart';

class Slide extends StatelessWidget {
  const Slide({super.key, required this.data});

  final SlideData data;

  @override
  Widget build(BuildContext context) {
    final textColor = context
        .select((SettingsCubit<PresenterSettings> s) => s.state.textColor);

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
              color: textColor,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
          if (data.subtitle != null)
            Text(
              data.subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w400,
                color: textColor,
                height: 1.1,
              ),
            )
        ],
      ),
    );
  }
}
